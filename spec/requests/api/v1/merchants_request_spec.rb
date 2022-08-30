require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful
    expect(response.status).to eq(200)

    parsed_json = JSON.parse(response.body, symbolize_names: true)

    merchants = parsed_json[:data]

    merchants.each do |m|
      expect(m).to have_key(:id)
      expect(m[:id]).to be_a(String)
      
      expect(m).to have_key(:attributes)
      expect(m[:attributes][:name]).to be_a(String)
    end
  end
end