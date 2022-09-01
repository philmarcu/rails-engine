class Api::V1::ItemSearchController < ApplicationController
  def find_all
    if !params[:name].empty?
      found = Item.search(params[:name])
      json_response(ItemSerializer.new(found))
    else
      render status: 400
    end
  end

  def find
    if params[:max_price].present?
      found = Item.range(params[:min_price], params[:max_price])
      json_response(ItemSerializer.new(found))
    else
      items = Item.price(params[:min_price])
      json_response(ItemSerializer.new(items))
    end
  end
end