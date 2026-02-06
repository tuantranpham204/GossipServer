# frozen_string_literal: true

class Api::V1::Users::ConfirmationsController < Devise::ConfirmationsController
  include ApiStandardization
  include ErrorHandlers
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    client_url = Rails.env.production? ? ENV.fetch("PROD_CLIENT_URL") : ENV.fetch("DEV_CLIENT_URL", "http://localhost:5173")

    token = params[:confirmation_token]
    if token.blank?
      return redirect_to "#{client_url}/activation?confirmed=invalid"
    end

    self.resource = resource_class.confirm_by_token(token)

    if resource.errors.empty?
      redirect_to "#{client_url}/activation?confirmed=true"
    elsif resource.errors.of_kind?(:email, :already_confirmed)
      redirect_to "#{client_url}/activation?confirmed=already"
    else
      redirect_to "#{client_url}/activation?confirmed=invalid"
    end
  end

  # protected
  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    client_url = Rails.env.production? ? ENV.fetch("PROD_CLIENT_URL") : ENV.fetch("DEV_CLIENT_URL", "http://localhost:5173")
    "#{client_url}/activation?confirmed=true"
  end
end
