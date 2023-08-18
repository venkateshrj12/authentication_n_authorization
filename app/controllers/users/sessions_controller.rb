# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to? :json
  before_action :authenticate_user!

  private
  def respond_with(resource, options={})
    render json: {message: "User signed in successfuldely", data: current_user}, status: 200
  end

  def respond_to_on_destroy
    begin
      jwt_payload = JWT.decode(request.headers["Authorization"].split(" ")[1], Rails.application.credentials.fetch(:secret_key_base)).first
      # current_user = User.find(jwt_payload['sub'])

      render json: {message: "#{current_user.email} Signed out succesfully"}, status: 200
    rescue JWT::DecodeError => e
      render json: { error: "Token can not be blank!", message: "Please provide valid bearer token for authentication"}, status: 401
    rescue JWT::ExpiredSignature => e
      render json: { message: "Token has been expired, please sign in again" }, status: 401
    end
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
