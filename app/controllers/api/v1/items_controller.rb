class Api::V1::ItemsController < ApplicationController
  def merc_index
    merchant = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items)
  end

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: 201
    else
      render status: 404
    end
  end

  def update
    item = Item.find(params[:id])
    if item.save
      item.update!(item_params)
      render json: ItemSerializer.new(item), status: 200
    else
      render status: 404
    end
  end

  def destroy
    render json: Item.destroy(params[:id])
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end