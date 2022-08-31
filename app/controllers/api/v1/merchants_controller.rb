class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  def find
    if params[:name]
      found = Merchant.search(params[:name])
      first = found.first
      render json: MerchantSerializer.new(first)
    else
    end
  end
end