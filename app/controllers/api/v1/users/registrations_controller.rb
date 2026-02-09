# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  include ApiStandardization
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource sign_up_params
    if resource.save
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        succeed(data: { user_id: resource.id }, message: I18n.t("devise.registrations.signed_up"), status: :created)
      else
        expire_data_after_sign_in!
        succeed(message: I18n.t("devise.failure.unconfirmed"), data: { user_id: resource.id }, status: :created)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      error_message_builder = ""
      resource.errors.full_messages.each do |error_message|
        error_message_builder += error_message.to_s + ", "
      end
      error(
        message: "#{I18n.t("errors.validation_error")}: #{error_message_builder.chomp(", ")}.",
        status: :unprocessable_content
      )
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def sign_up_params
    {
      email: params[:user][:email],
      password: params[:user][:password],
      password_confirmation: params[:user][:password_confirmation],
      username: params[:user][:username],
      profile_attributes: {
        name: params[:user][:name],
        surname: params[:user][:surname],
        gender: params[:user][:gender],
        dob: params[:user][:dob]
      }
    }
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
