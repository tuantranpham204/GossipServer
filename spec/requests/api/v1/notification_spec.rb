require 'swagger_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'api/v1/notifications', type: :request do
   path '/api/v1/notifications/show_by_user' do
    get 'Show notifications by current user' do
      tags 'Notifications'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :page, in: :query, type: :integer, description: 'Page number', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page', required: false

      response '200', 'notifications found' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                user_id: { type: :integer },
                actor_id: { type: :integer },
                actor_username: { type: :string },
                actor_avatar_url: { type: :string, nullable: true },
                status: { type: :integer },
                notifiable_type: { type: :integer },
                content: { type: :object },
                updated_at: { type: :string, format: :date_time },
                created_at: { type: :string, format: :date_time }
              }
            }
          }

        run_test!
      end
    end
   end

   path '/api/v1/notifications/read/{id}' do
    patch 'Read a notification' do
    tags 'Notifications'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :id, in: :path, type: :integer, description: 'Notification ID', required: true

      response '200', 'notification read' do
        run_test!
      end
    end
   end

   path '/api/v1/notifications/read_all' do
    patch 'Read all notifications' do
    tags 'Notifications'
      produces 'application/json'
      security [ Bearer: [] ]

      response '200', 'all notifications read' do
        run_test!
      end
    end
   end
end
