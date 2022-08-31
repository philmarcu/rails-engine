class Api::V1::MerchantsSearchController < ApplicationController
  def find
    found = Merchant.search(params[:name])
    if !found.blank?
      first = found.first
      json_response(MerchantSerializer.new(first))
    else
      json_response({ data: {} })
    end
  end
end