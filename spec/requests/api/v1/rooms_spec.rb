require 'rails_helper'

RSpec.describe "Api::V1::Rooms", type: :request do
  path '/api/v1/rooms/private/show/{status}' do
    get 'Show private rooms' do
      tags 'Rooms'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :page, in: :query, type: :integer, description: 'Page number', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page', required: false
      parameter name: :status, in: :path, type: :string, description: 'Room status', required: false

      response '200', 'private rooms found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  room_type: { type: :string },
                  created_at: { type: :string, format: :date_time },
                  updated_at: { type: :string, format: :date_time },
                  opponent: {
                    type: :object,
                    properties: {
                      participant_id: { type: :integer },
                      user_id: { type: :integer },
                      role: { type: :string },
                      avatar_url: { type: :string },
                      name: { type: :string },
                      surname: { type: :string },
                      username: { type: :string }
                    }
                  }
                }
              }
            },
            meta: {
              type: :object,
              properties: {
                total_pages: { type: :integer },
                current_page: { type: :integer },
                per_page: { type: :integer },
                total_count: { type: :integer }
              }
            }
          }

        run_test!
      end
    end
  end

  path '/api/v1/rooms/private/request/{receiver_id}' do
    post 'Request a private room' do
      tags 'Rooms'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :receiver_id, in: :path, type: :integer, description: 'Receiver ID', required: true

      response '201', 'private room requested' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                room_type: { type: :string },
                created_at: { type: :string, format: :date_time },
                updated_at: { type: :string, format: :date_time },
                participants: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      room_id: { type: :integer },
                      user_id: { type: :integer },
                      created_at: { type: :string, format: :date_time },
                      updated_at: { type: :string, format: :date_time }
                    }
                  }
                }
              }
            },
            message: { type: :string }
          }

        run_test!
      end
    end
  end

  path '/api/v1/rooms/private/accept/{room_id}' do
    patch 'Accept a private room request' do
      tags 'Rooms'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :room_id, in: :path, type: :integer, description: 'Room ID', required: true

      response '200', 'private room accepted' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        run_test!
      end
    end
  end

  path '/api/v1/rooms/private/decline/{room_id}' do
    patch 'Decline a private room request' do
      tags 'Rooms'
      consumes 'application/json'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :room_id, in: :path, type: :integer, description: 'Room ID', required: true

      response '200', 'private room declined' do
        schema type: :object,
          properties: {
            message: { type: :string }
          }

        run_test!
      end
    end
  end
end
