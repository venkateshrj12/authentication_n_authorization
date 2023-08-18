class ApplicationController < ActionController::API

  def authenticate_user!
    unless user_signed_in?
      render json: { error: "Token has been expired, please sign in again" }, status: :unauthorized
    end
  end
end
