class Api::V1::MerchantSearchController < ApplicationController
  def find
    found = Merchant.search(params[:name])
    if params[:name].empty?
      render status: 400
    elsif !found.blank?
      first = found.first
      json_response(MerchantSerializer.new(first))
    else
      json_response({ data: {} })
    end
  end

  def find_all
    if !params[:name].empty?
      found = Merchant.search(params[:name])
      json_response(MerchantSerializer.new(found))
    else
      render status: 400
    end
  end
end