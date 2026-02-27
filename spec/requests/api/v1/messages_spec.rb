require 'swagger_helper'
require 'devise/jwt/test_helpers'

RSpec.describe '/api/v1/messages', type: :request do
  path '/api/v1/messages/create/{room_id}' do
    post 'Creates a message with optional media attachments' do
      tags 'Messages'
      consumes 'multipart/form-data'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :room_id, in: :path, type: :string, description: 'ID of the room'

      parameter name: :message, in: :body, schema: {
        type: :object,
        properties: {
          content: {
            type: :string,
            description: 'Text content of the message',
            example: 'Here are the requested files!'
          },
          'attachments[]': {
            type: :array,
            items: { type: :string, format: :binary },
            description: 'Select one or more media files to attach'
          }
        },
        required: [ 'content' ]
      }

      response '201', 'Message successfully created' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Message sent successfully.' },
            data: {
              type: :object,
              properties: {
                id: { type: :integer },
                room_id: { type: :integer },
                sender_id: { type: :integer },
                content: { type: :string },
                status_data: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      participant_id: { type: :integer },
                      user_id: { type: :integer },
                      status: { type: :integer }
                    }
                  }
                },
                attachments: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      blob_id: { type: :integer },
                      filename: { type: :string },
                      mime_type: { type: :string },
                      file_size: { type: :integer },
                      url: { type: :string, format: :uri }
                    }
                  }
                }
              }
            }
          }

        let(:'attachments[]') do
          [
            fixture_file_upload(Rails.root.join('spec/fixtures/files/test.png'), 'image/png'),
            fixture_file_upload(Rails.root.join('spec/fixtures/files/doc.pdf'), 'application/pdf')
          ]
        end

        run_test!
      end
    end
  end

  path '/api/v1/messages/get_messages/{room_id}' do
    get 'Get messages by room ID' do
      tags 'Messages'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :room_id, in: :path, type: :string, description: 'ID of the room'

      response '200', 'Messages retrieved successfully' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Messages retrieved successfully.' },
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  room_id: { type: :integer },
                  sender_id: { type: :integer },
                  content: { type: :string },
                  status_data: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        participant_id: { type: :integer },
                        user_id: { type: :integer },
                        status: { type: :integer }
                      }
                    }
                  },
                  attachments: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        blob_id: { type: :integer },
                        filename: { type: :string },
                        mime_type: { type: :string },
                        file_size: { type: :integer },
                        url: { type: :string, format: :uri }
                      }
                    }
                  }
                }
              }
            }
          }

        run_test!
      end
    end
  end

  path '/api/v1/messages/get_messages/{room_id}' do
    get 'Get messages by room ID' do
      tags 'Messages'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :room_id, in: :path, type: :string, description: 'ID of the room'

      response '200', 'Messages retrieved successfully' do
        schema type: :object,
          properties: {
            message: { type: :string, example: 'Messages retrieved successfully.' },
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  room_id: { type: :integer },
                  sender_id: { type: :integer },
                  content: { type: :string },
                  status_data: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        participant_id: { type: :integer },
                        user_id: { type: :integer },
                        status: { type: :integer }
                      }
                    }
                  },
                  attachments: {
                    type: :array,
                    items: {
                      type: :object,
                      properties: {
                        blob_id: { type: :integer },
                        filename: { type: :string },
                        mime_type: { type: :string },
                        file_size: { type: :integer },
                        url: { type: :string, format: :uri }
                      }
                    }
                  }
                }
              }
            }
          }

        run_test!
      end
    end
  end
end
