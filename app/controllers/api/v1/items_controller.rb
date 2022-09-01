class Api::V1::ItemsController < ApplicationController
  def merchant
    item = Item.find(params[:item_id])
    merchant = Merchant.find(item.merchant_id)
    json_response(MerchantSerializer.new(merchant))
  end

  def index
    json_response(ItemSerializer.new(Item.all))
  end

  def show
    json_response(ItemSerializer.new(Item.find(params[:id])))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    end
  end

  def update
    item = Item.find(params[:id])
    merchant = Merchant.find(item.merchant_id)
    if item.save && merchant.valid
      item.update!(item_params)
      json_response(ItemSerializer.new(item))
    end
  end

  def destroy
    json_response(Item.destroy(params[:id])) # must delete invoices as well
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end