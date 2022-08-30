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

  it 'can create a new merchant' do
    merc_params = ({
      name: Faker::Name.name
    })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merc_params)
    created_merc = Merchant.last

    expect(response).to be_successful
    expect(response.status).to eq(201)
    expect(created_merc.name).to eq(merc_params[:name])
  end
end