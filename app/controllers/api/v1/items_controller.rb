class Api::V1::ItemsController < ApplicationController
  def merc_index
    merchant = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items)
  end

  def index
    render json: ItemSerializer.new(Item.all)
  end
end