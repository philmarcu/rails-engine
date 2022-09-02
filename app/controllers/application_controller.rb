class ApplicationController < ActionController::API
  include Response
  include ExceptionHandler
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found_404

  private 

  def bad_request_400
    render status: 400
  end
end

  # def not_found_404
  #   render status: 404
  # end
