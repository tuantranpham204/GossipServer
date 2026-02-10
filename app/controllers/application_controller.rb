class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  include Pundit::Authorization
  include ApiStandardization
  include ErrorHandlers
  before_action :set_locale

  # Devise is namespaced in config/routes.rb (namespace :api { namespace :v1 { devise_for :users } })
  # So the helpers are current_api_v1_user and authenticate_api_v1_user!
  # Pundit expects current_user, so we alias it.
  def current_user
    current_api_v1_user
  end
  def authenticate_user!
    authenticate_api_v1_user!
  end

  private

  def set_locale
    I18n.locale = extract_locale_from_header || I18n.default_locale
  end

  def extract_locale_from_header
    header = request.headers["Accept-Language"]
    return nil unless header

    parsed_locale = header.scan(/^[a-z]{2}/).first&.to_sym
    I18n.available_locales.include?(parsed_locale) ? parsed_locale : nil
  end
end
