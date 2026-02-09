class CustomDeviseFailureApp < Devise::FailureApp
  include ApiStandardization
  def respond
    begin
      if request.format == :json || request.content_type.to_s.include?("json")
        self.status = :unauthorized
        self.content_type = "application/json"

        self.response_body = {
          code: Rack::Utils.status_code(self.status),
          status: self.status,
          message: i18n_message,
          data: nil,
          errors: nil
        }.to_json
      else
        error(message: "Cannot raise devise error automatically: #{i18n_message}", status: :unauthorized)
      end
    rescue => e
      error(message: "Cannot raise devise error automatically: #{e.message}", status: :unauthorized, data: { devise_message: i18n_message }, errors: e.backtrace.join("\n"))
    end
  end
end
