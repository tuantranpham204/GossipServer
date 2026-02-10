# frozen_string_literal: true

class Api::V1::Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    user = User.find_by(email: sign_in_params[:email])
    if user != nil && user.valid_password?(sign_in_params[:password])
      sign_in(resource_name, user)
      @token = request.env["warden-jwt_auth.token"]
      respond_with user, location: after_sign_in_path_for(user)
    else
      # Fallback to warden authentication
      # self.resource = warden.authenticate!(auth_options)
      # sign_in(resource_name, resource)
      # @token = request.env["warden-jwt_auth.token"]
      # respond_with resource, location: after_sign_in_path_for(resource)
      error(message: I18n.t("devise.failure.invalid", authentication_keys: "email", default: "Invalid email or password."), status: :unauthorized)
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def sign_in_params
    params.require(:user).permit(:email, :password)
  end


  private

  # Check if there is no signed in user before doing the sign out.
  #
  # If there is no signed in user, it will set the flash message and redirect
  # to the after_sign_out path.
  def verify_signed_out_user
    begin
      if all_signed_out?
        succeed(data: {}, message: I18n.t("devise.sessions.signed_out"), status: :ok)
      end
    rescue => e
      error(message: I18n.t("devise.failure.already_signed_out", authentication_keys: "email", default: "Already signed out."), status: e.status, errors: e.backtrace.join("\n"))
    end
  end

  def all_signed_out?
    users = Devise.mappings.keys.map { |s| warden.user(scope: s, run_callbacks: false) }
    users.all?(&:blank?)
  end


  # Devise-JWT adds the token to the HEADER automatically.
  # Json response for sign in
  def respond_with(resource, _opts = {})
    if action_name == "create"
      succeed(data: {
        token: @token,
        user: {
          id: resource.id,
          username: resource.username,
          roles: resource.roles,
          name: resource.profile.name,
          surname: resource.profile.surname,
          avatar_url: resource.profile.avatar_url
        }
    }, message: I18n.t("devise.sessions.signed_in"))
    else
      error(message: I18n.t("devise.failure.invalid", authentication_keys: "email", default: "Invalid email or password."), status: :unauthorized)
    end
  end
end
