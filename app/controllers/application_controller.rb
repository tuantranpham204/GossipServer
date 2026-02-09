class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  include Pundit::Authorization
  include ApiStandardization
  include ErrorHandlers

  # Devise is namespaced in config/routes.rb (namespace :api { namespace :v1 { devise_for :users } })
  # So the helpers are current_api_v1_user and authenticate_api_v1_user!
  # Pundit expects current_user, so we alias it.
  def current_user
    current_api_v1_user
  end
  def authenticate_user!
    authenticate_api_v1_user!
  end
end
