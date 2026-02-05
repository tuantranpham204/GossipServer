class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  include ApiStandardization
  include ErrorHandlers
end
