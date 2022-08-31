require 'rails_helper'

RSpec.describe 'items API' do
  it 'sends a list of items' do
    create_list(:item, 3)

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
    id = create(:item).id
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

  it 'can create a new item' do
    item_params = ({
      name: Faker::Appliance.equipment, 
      description: Faker::Lorem.paragraph,
      unit_price: Faker::Commerce.price(range: 0..2000.0, as_string: false)
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created = Item.last

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(created.name).to eq(item_params[:name])
    expect(created.description).to eq(item_params[:description])
  end

  # it 'sad path renders 404 if invalid params for create' do
  #   item_params = ({
  #     name: nil,
  #     description: nil,
  #     unit_price: nil
  #   })
  #   headers = {"CONTENT_TYPE" => "application/json"}
    
  #   post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

  #   expect(response.status).to eq(400)
  # end

  it 'can update an item' do
    merchant = create_list(:merchant, 1).first
    merchant.items = create_list(:item, 1)
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

    expect(response.status).to eq(200)
    expect(item.name).to_not eq(old_name)
    expect(item.name).to eq('new name who dis')

    expect(item.description).to_not eq(old_desc)
    expect(item.description).to eq('asdlkjsakl jj dalksj kdska jlsddsda s')

    expect(item.unit_price).to_not eq(old_price)
    expect(item.unit_price).to eq(29.99)
  end

  it 'can delete an item' do
    item = create(:item)

    expect(Item.count).to eq(1)

    expect{delete "/api/v1/items/#{item.id}"}.to change(Item, :count).by(-1)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'can get an items merchant' do
    merchant = create_list(:merchant, 1).first
    merchant.items = create_list(:item, 1)
    item = merchant.items.first

    get "/api/v1/items/#{item.id}/merchant"
    parsed_json = JSON.parse(response.body, symbolize_names: true)
    found = parsed_json[:data]

    expect(found[:id].to_i).to eq(merchant.id)
    expect(found[:attributes][:name]).to eq(merchant.name)
  end
end