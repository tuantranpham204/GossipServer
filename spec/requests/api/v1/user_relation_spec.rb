require 'swagger_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'api/v1/user_relations', type: :request do
  path '/api/v1/user_relations/pending/{relation_type}' do
    get('get user relations pending requests') do
      tags 'User Relations'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :relation_type, in: :path, type: :string, required: true
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

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
            },
            meta: {
              type: :object,
              properties: {
                total_pages: { type: :integer },
                total_count: { type: :integer },
                current_page: { type: :integer },
                per_page: { type: :integer }
              }
            }
          }
        run_test!
      end
    end
  end

  path '/api/v1/user_relations/accepted/{relation_type}' do
    get('get user relations accepted requests') do
      tags 'User Relations'
      produces 'application/json'
      security [ Bearer: [] ]
      parameter name: :relation_type, in: :path, type: :string, required: true
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false

      response '200', 'User relations found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
                  capacity: { type: :string },
                  user_id: { type: :integer },
                  username: { type: :string },
                  email: { type: :string, nullable: true },
                  name: { type: :string },
                  surname: { type: :string },
                  bio: { type: :string, nullable: true },
                  dob: { type: :string, format: :date, nullable: true },
                  gender: { type: :string, nullable: true },
                  relationship_status: { type: :string, nullable: true },
                  status: { type: :string, nullable: true },
                  avatar_url: { type: :string, nullable: true },
                  bg_img_url: { type: :string, nullable: true },
                  followers_amt: { type: :integer },
                  following_amt: { type: :integer },
                  is_email_public: { type: :boolean },
                  is_gender_public: { type: :boolean },
                  is_rel_status_public: { type: :boolean },
                  friend_status: { type: :string },
                  follow_status: { type: :string }
                }
              }
            },
            meta: {
              type: :object,
              properties: {
                total_pages: { type: :integer },
                total_count: { type: :integer },
                current_page: { type: :integer },
                per_page: { type: :integer }
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
            },
            meta: {
              type: :object,
              properties: {
                total_pages: { type: :integer },
                total_count: { type: :integer },
                current_page: { type: :integer },
                per_page: { type: :integer }
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
