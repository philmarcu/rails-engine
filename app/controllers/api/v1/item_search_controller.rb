class Api::V1::ItemSearchController < ApplicationController
  def find_all
    if !params[:name].empty?
      found = Item.search(params[:name])
      json_response(ItemSerializer.new(found))
    else
      bad_request_400
    end
  end

  def find
    min = params[:min_price]
    max = params[:max_price]
    if max.present? && min.present?
      found = Item.range(params[:min_price], params[:max_price])
      json_response(ItemSerializer.new(found))
    elsif min.present?
      min_found = Item.price(params[:min_price])
      json_response(ItemSerializer.new(min_found))
    else
      max_found = Item.mx_price(params[:max_price])
      json_response(ItemSerializer.new(max_found))
    end
  end
end