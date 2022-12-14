require 'rails_helper'

RSpec.describe 'items API' do
  let(:m) {create(:merchant)}

  it 'sends a list of items' do
    create_list(:item, 3, merchant_id: m.id)

    get '/api/v1/items'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    parsed_json = JSON.parse(response.body, symbolize_names: true)
    items = parsed_json[:data]

    expect(items.size).to eq(3)

    items.each do |i|
      attrib = i[:attributes]

      expect(i).to have_key(:id)
      expect(i[:id]).to be_a(String)

      expect(i).to have_key(:attributes)
      expect(attrib[:name]).to be_a(String)
      expect(attrib[:description]).to be_a(String)
      expect(attrib[:unit_price]).to be_a(Float)
    end
  end

  it 'gets a specific item' do
    id = create(:item, merchant_id: m.id).id
    get "/api/v1/items/#{id}"

    expect(response).to be_successful
    expect(response.status).to eq(200)

    parsed_json = JSON.parse(response.body, symbolize_names: true)
    item = parsed_json[:data]

    expect(item[:id]).to be_a(String)
    expect(item[:attributes][:name]).to be_a(String)
    expect(item[:attributes][:description]).to be_a(String)
    expect(item[:attributes][:unit_price]).to be_a(Float)
  end

  it 'sad path- will not find specific item with invalid id' do
    get "/api/v1/items/L"

    parsed_json = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(404)
    expect(response.body).to include("Couldn't find Item with 'id'=L")
  end

  it 'can create a new item' do
    item_params = ({
      name: Faker::Appliance.equipment, 
      description: Faker::Lorem.paragraph,
      unit_price: Faker::Commerce.price(range: 0..2000.0, as_string: false),
      merchant_id: m.id
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created = Item.last

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(created.name).to eq(item_params[:name])
    expect(created.description).to eq(item_params[:description])
  end

  it 'sad path renders 204 if invalid params for create' do
    item_params = ({
      name: "bobby",
      unit_price: 209.00,
      merchant_id: m.id
    })
    headers = {"CONTENT_TYPE" => "application/json"}
    
    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    expect(response.status).to eq(204)
  end

  it 'can update an item' do
    merchant = create_list(:merchant, 1).first
    merchant.items = create_list(:item, 1, merchant_id: merchant.id)
    id = merchant.items.first.id
    old_name = Item.last.name
    old_desc = Item.last.description
    old_price = Item.last.unit_price

    item_params = {
      name: 'new name who dis',
      description: 'asdlkjsakl jj dalksj kdska jlsddsda s',
      unit_price: 29.99,
    }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)
    item = Item.find(id)

    expect(response.status).to eq(201)
    expect(item.name).to_not eq(old_name)
    expect(item.name).to eq('new name who dis')

    expect(item.description).to_not eq(old_desc)
    expect(item.description).to eq('asdlkjsakl jj dalksj kdska jlsddsda s')

    expect(item.unit_price).to_not eq(old_price)
    expect(item.unit_price).to eq(29.99)
  end

  it 'sad path- will not update if invalid merchant_id' do
    id = create(:item, merchant_id: m.id).id
    item_params = {
      name: 'new name who dis',
      description: 'asdlkjsakl jj dalksj kdska jlsddsda s',
      unit_price: 29.99,
      merchant_id: 999999999999
    }
    headers = {"CONTENT_TYPE" => "application/json"}
    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate(item: item_params)

    expect(response.status).to eq(404)
    # --- old expect for old update action --- #
    # expect(response.body).to include("Validation failed: Merchant must exist")
  end

  it 'can delete an item' do
    item = create(:item, merchant_id: m.id)

    expect(Item.count).to eq(1)

    expect{delete "/api/v1/items/#{item.id}"}.to change(Item, :count).by(-1)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can get an items merchant' do
    merchant = create_list(:merchant, 1).first
    merchant.items = create_list(:item, 1, merchant_id: m.id)
    item = merchant.items.first

    get "/api/v1/items/#{item.id}/merchant"
    parsed_json = JSON.parse(response.body, symbolize_names: true)
    found = parsed_json[:data]

    expect(found[:id].to_i).to eq(merchant.id)
    expect(found[:attributes][:name]).to eq(merchant.name)
  end

  it 'can search for many items by name' do
    items = create_list(:item, 20, merchant_id: m.id)
    query = 'an'

    get "/api/v1/items/find_all?name=#{query}"

    parsed_json = JSON.parse(response.body, symbolize_names: true)
    found = parsed_json[:data]

    result = found.first
    name = result[:attributes][:name].downcase

    expect(response).to be_successful
    expect(found).to be_a(Array)
    expect(found.size).to_not eq(20)
    expect(result).to be_a(Hash)
    expect(name).to include(query.downcase)
  end

  it 'sad path- will not return items if search is blank' do
    items = create_list(:item, 20, merchant_id: m.id)
    query = ''

    get "/api/v1/items/find_all?name=#{query}"

    expect(response.status).to eq(400)
  end

  it 'can search for an item by min price' do
    items = create_list(:item, 20, merchant_id: m.id)
    price = 1000.00

    get "/api/v1/items/find?min_price=#{price}"

    parsed_json = JSON.parse(response.body, symbolize_names: true)
    found = parsed_json[:data]
    result = found.first
    item_price = result[:attributes][:unit_price]
    
    expect(found).to be_a(Array)
    expect(found.size).to_not eq(20)
    expect(result).to be_a(Hash)
    expect(item_price).to be >= price
  end

  it 'can search for an item by max price' do
    items = create_list(:item, 20, merchant_id: m.id)
    price = 400.00

    get "/api/v1/items/find?max_price=#{price}"

    parsed_json = JSON.parse(response.body, symbolize_names: true)
    found = parsed_json[:data]
    result = found.first
    item_price = result[:attributes][:unit_price]
    
    expect(found).to be_a(Array)
    expect(found.size).to_not eq(20)
    expect(result).to be_a(Hash)
    expect(item_price).to be <= price
  end

  it 'can get items in a price range' do
    items = create_list(:item, 20, merchant_id: m.id)
    min = 200.00
    max = 1000.00

    get "/api/v1/items/find?max_price=#{max}&min_price=#{min}"
    
    parsed_json = JSON.parse(response.body, symbolize_names: true)
    found = parsed_json[:data]
    result = found.first
    item_price = result[:attributes][:unit_price]

    expect(found).to be_a(Array)
    expect(found.size).to_not eq(20)
    expect(item_price).to be >= min
    expect(item_price).to be <= max
  end
end