module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      # json_response({ message: e.message }, :unprocessable_entity)
    end
  end
end

# ----- line 10 is needed for validation expect in item#update sad path test (line 127-129)