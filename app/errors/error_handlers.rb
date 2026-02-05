module ErrorHandlers
  # Allows this module to be included in classes
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :handle_standard_error
  end

  private

  def handle_standard_error(e)
    error(
      message: e.message,
      errors: e.backtrace.join("\n"),
      status: e.status || :internal_server_error
    )
  end
end
