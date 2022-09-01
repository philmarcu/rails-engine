class Api::V1::MerchantsController < ApplicationController
  def index
    json_response(MerchantSerializer.new(Merchant.all))
  end

  def show
    json_response(MerchantSerializer.new(Merchant.find(params[:id])))
  end

  def items
    merchant = Merchant.find(params[:merchant_id])
    json_response(ItemSerializer.new(merchant.items))
  end
end