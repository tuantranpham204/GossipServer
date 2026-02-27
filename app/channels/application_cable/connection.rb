module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include ApiStandardization
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      token = request.params[:token]
      reject_unauthorized_connection unless token

      begin
        payload = Warden::JWTAuth::TokenDecoder.new.call(token)

        if JwtDenylist.exists?(jti: payload['jti'])
          reject_unauthorized_connection
          error(message: I18n.t("devise.failure.invalid", authentication_keys: "email", default: "Unauthenticated"), status: :unauthorized)
        end
        user = User.find_by(id: payload['sub'])
        user || reject_unauthorized_connection

      rescue StandardError => e
        Rails.logger.error "WebSocket Auth Failed: #{e.message}"
        reject_unauthorized_connection
        error(message: I18n.t("devise.failure.invalid", authentication_keys: "email", default: "Unauthenticated"), status: :unauthorized)
      end
    end
  end
end