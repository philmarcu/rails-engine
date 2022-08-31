class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found_404

  # private 

  # def not_found_404
  #   render status: 404
  # end
end
