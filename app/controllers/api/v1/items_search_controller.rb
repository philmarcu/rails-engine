class Api::V1::ItemsSearchController < ApplicationController
  def find_all
    found = Item.search(params[:name])
    json_response(ItemSerializer.new(found))
  end
end