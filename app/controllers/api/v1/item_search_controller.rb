class Api::V1::ItemSearchController < ApplicationController
  def find_all
    found = Item.search(params[:name])
    json_response(ItemSerializer.new(found))
  end

  def find
    items = Item.price(params[:min_price])
    json_response(ItemSerializer.new(items))
  end
end