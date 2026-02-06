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
    token = params[:confirmation_token]
    if token.blank?
      return redirect_to activation_url("invalid")
    end

    self.resource = resource_class.confirm_by_token(token)

    if resource.errors.empty?
      redirect_to activation_url("confirmed")
    elsif resource.errors.of_kind?(:email, :already_confirmed)
      redirect_to activation_url("already")
    else
      redirect_to activation_url("invalid")
    end
  end

  protected
  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    activation_url("confirmed")
  end

  private

  def activation_url(status)
    client_url = Rails.env.production? ? ENV.fetch("PROD_CLIENT_URL") : ENV.fetch("DEV_CLIENT_URL", "http://localhost:5173")
    "#{client_url}/auth?activation_status=#{status}"
  end
end
