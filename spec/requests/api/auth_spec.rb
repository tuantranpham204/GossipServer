require 'swagger_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'api/v1/users', type: :request, swagger_doc: 'v1/swagger.yaml' do
  path '/api/v1/users/sign_up' do
    post('Sign Up') do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              username: { type: :string },
              email: { type: :string, default: ENV["DEMO_ACTIVATION_EMAIL_ADDRESS"] },
              password: { type: :string, default: ENV["DEFAULT_ACCOUNT_PASSWORD"] },
              password_confirmation: { type: :string, default: ENV["DEFAULT_ACCOUNT_PASSWORD"] },
              name: { type: :string },
              surname: { type: :string },
              gender: { type: :integer, default: 1 },
            dob: { type: :string, format: 'date', example: '2000-01-01' }
            },
            required: %w[username email password password_confirmation name surname gender dob]
          }
        }
      }

      response(200, 'successful') do
        # This captures the actual response from your API for the example
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end

      response(401, 'unauthorized') do
        run_test!
      end
    end
  end
end
