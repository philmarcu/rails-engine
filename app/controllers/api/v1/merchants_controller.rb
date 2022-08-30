class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end

  # def create
  #   merchant = Merchant.new(merc_params)
  #   if merchant.save
  #     render json: MerchantSerializer.new(merchant), status: 201
  #   end
  # end
  
  # private

  # def merc_params
  #   params.require(:merchant).permit(:name)
  # end