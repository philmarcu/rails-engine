require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    parsed_json = JSON.parse(response.body, symbolize_names: true)
    merchants = parsed_json[:data]

    expect(merchants.size).to eq(3)

    merchants.each do |m|
      expect(m).to be_a(Hash)
      expect(m.size).to eq(3)
      expect(m).to have_key(:id)
      expect(m[:id]).to be_a(String)
      
      expect(m).to have_key(:attributes)
      expect(m[:type]).to eq("merchant")
      expect(m[:attributes][:name]).to be_a(String)
    end
  end

  it 'can get a specific merchant' do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    parsed_json = JSON.parse(response.body, symbolize_names: true)
    merchant = parsed_json[:data]

    expect(merchant[:id]).to be_a(String)
    expect(merchant[:attributes][:name]).to be_a(String)
  end

  it 'sad path- will not find merchant with invalid id' do
    get "/api/v1/merchants/L"

    expect(response.status).to eq(404)
    expect(response.body).to include("Couldn't find Merchant with 'id'=L")
  end

  it 'can get a merchants items' do
    merchant = create_list(:merchant, 1).first
    merchant.items = create_list(:item, 3, merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"
    
    parsed_json = JSON.parse(response.body, symbolize_names: true)
    items = parsed_json[:data]

    expect(items.count).to eq(3)
  end

  it 'can search for merchant by name' do
    merchants = create_list(:merchant, 20)
    query = 'A'

    get "/api/v1/merchants/find?name=#{query}"

    parsed_json = JSON.parse(response.body, symbolize_names: true)
    found = parsed_json[:data]

    expect(response).to be_successful
    expect(found).to be_a(Hash)
    expect(found.size).to eq(3)
    expect(found).to have_key(:attributes)
    expect(found[:attributes][:name].downcase).to include(query.downcase)
  end

  it 'sad path- returns an error message if no merchants found' do
    merchants = create_list(:merchant, 20)
    query = "?!?!"

    get "/api/v1/merchants/find?name=#{query}", params: {}
    parsed_json = JSON.parse(response.body, symbolize_names: true)
    results = parsed_json[:data]

    expect(response.body).to eq("{\"data\":{}}")
    expect(results).to be_a(Hash)
    expect(results.blank?).to eq(true)
  end

  it 'sad path- will not return a merchant if search is blank' do
    merchants = create_list(:merchant, 20)
    query = ''

    get "/api/v1/merchants/find?name=#{query}"

    expect(response.status).to eq(400)
  end

  it 'can search for many merchants by name' do
    merchants = create_list(:merchant, 20)
    query = 'la'

    get "/api/v1/merchants/find_all?name=#{query}"

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

  it 'sad path- will not return merchants if search is blank' do
    merchants = create_list(:merchant, 20)
    query = ''

    get "/api/v1/merchants/find_all?name=#{query}"

    expect(response.status).to eq(400)
  end
end