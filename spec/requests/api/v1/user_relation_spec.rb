require 'swagger_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'api/v1/user_relations', type: :request do
  path '/api/v1/user_relations/pending/{relation_type}' do
    get('get user relations pending requests') do
      tags 'User Relations'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :relation_type, in: :path, type: :string, required: true

      response '200', 'User relations found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  requester_id: { type: :integer },
                  receiver_id: { type: :integer },
                  relation_type: { type: :string },
                  status: { type: :string },
                  requester_avatar_url: { type: :string, nullable: true },
                  requester_name: { type: :string },
                  requester_surname: { type: :string },
                  requester_username: { type: :string }
                }
              }
            }
          }
        run_test!
      end
    end
  end

  path '/api/v1/user_relations/{relation_type}' do
    get('get user relations') do
      tags 'User Relations'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :relation_type, in: :path, type: :string, required: true

      response '200', 'User relations found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  requester_id: { type: :integer },
                  receiver_id: { type: :integer },
                  relation_type: { type: :string },
                  status: { type: :string },
                  requester_avatar_url: { type: :string, nullable: true },
                  requester_name: { type: :string },
                  requester_surname: { type: :string },
                  requester_username: { type: :string }
                }
              }
            }
          }
        run_test!
      end
    end
  end

  path '/api/v1/user_relations/friend/{receiver_id}' do
    post('request friend') do
      tags 'User Relations'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :receiver_id, in: :path, type: :integer, required: true

      response '200', 'User relations found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  requester_id: { type: :integer },
                  receiver_id: { type: :integer },
                  relation_type: { type: :string },
                  status: { type: :string },
                  requester_avatar_url: { type: :string, nullable: true },
                  requester_name: { type: :string },
                  requester_surname: { type: :string },
                  requester_username: { type: :string }
                }
              }
            }
          }
        run_test!
      end
    end
  end

  path '/api/v1/user_relations/follow/{receiver_id}' do
    post('request follow') do
      tags 'User Relations'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :receiver_id, in: :path, type: :integer, required: true

      response '200', 'User relations found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  requester_id: { type: :integer },
                  receiver_id: { type: :integer },
                  relation_type: { type: :string },
                  status: { type: :string },
                  requester_avatar_url: { type: :string, nullable: true },
                  requester_name: { type: :string },
                  requester_surname: { type: :string },
                  requester_username: { type: :string }
                }
              }
            }
          }
        run_test!
      end
    end
  end

  path '/api/v1/user_relations/accept/{relation_type}/{requester_id}' do
    patch('accept request') do
      tags 'User Relations'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :relation_type, in: :path, type: :string, required: true
      parameter name: :requester_id, in: :path, type: :integer, required: true

      response '200', 'User relations found' do
        run_test!
      end
    end
  end

  path '/api/v1/user_relations/decline/{relation_type}/{requester_id}' do
    patch('decline request') do
      tags 'User Relations'

      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :relation_type, in: :path, type: :string, required: true
      parameter name: :requester_id, in: :path, type: :integer, required: true

      response '200', 'User relations found' do
        run_test!
      end
    end
  end
end
