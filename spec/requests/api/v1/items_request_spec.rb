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
end