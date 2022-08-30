require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    binding.pry

    expect(response).to be_successful
    expect(response.status).to eq(200)
  end
end