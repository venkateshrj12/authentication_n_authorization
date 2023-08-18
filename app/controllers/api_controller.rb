class ApiController < ApplicationController
  def authenticate_user!
    unless user_signed_in?
      render json: { error: "Token has been expired, please sign in again" }, status: :unauthorized
    end
  end

  def set_pagination
    @page = params.fetch("page", "1").to_i
    @per_page = params.fetch("per_page", "10").to_i

    if @page < 1
      return render_bad_request_error("Invalid page count for pagination", "The page value should not be less than 1")
    end

    if @per_page < 1 || @per_page > 100
      return render_bad_request_error("Invalid per page count for pagination", "Please provide a value between 1 to 100")
    end
  end

  def render_bad_request_error(error_message, message)
    render json: { error: error_message, message: message }, status: 400
  end

  rescue_from CanCan::AccessDenied do |e|
    render json: e, status: :unauthorized
  end
end
