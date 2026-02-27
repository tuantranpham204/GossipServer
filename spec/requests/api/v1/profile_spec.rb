require 'swagger_helper'
require 'devise/jwt/test_helpers'

RSpec.describe 'api/v1/profiles', type: :request do
  path '/api/v1/profiles/search' do
    get 'Searches users by username or full name' do
      tags 'Profiles'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :q, in: :query, type: :string, description: 'Search term (username, first name, last name, full name, reversed full name)', required: false
      parameter name: :page, in: :query, type: :integer, description: 'Page number', required: false
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page', required: false

      response '200', 'search results found' do
        schema type: :object,
          properties: {
            data: {
              type: :array,
              items: {
                type: :object,
                properties: {
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
                  avatar_data: {
                    type: :object,
                    properties: {
                      url: { type: :string, nullable: true }
                    }
                  },
                  is_email_public: { type: :boolean },
                  is_gender_public: { type: :boolean },
                  is_rel_status_public: { type: :boolean }
                }
              }
            },
            meta: {
              type: :object,
              properties: {
                current_page: { type: :integer },
                next_page: { type: :integer, nullable: true },
                prev_page: { type: :integer, nullable: true },
                total_pages: { type: :integer },
                total_count: { type: :integer },
                per_page: { type: :integer }
              }
            }
          }

        run_test!
      end
    end
  end

  path '/api/v1/profiles/{id}' do
    get 'Show a specific profile' do
      tags 'Profiles'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :id, in: :path, type: :integer, description: 'User ID', required: true

      response '200', 'profile found' do
        schema type: :object,
          properties: {
            data: {
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
                avatar_data: {
                  type: :object,
                  properties: {
                    url: { type: :string, nullable: true }
                  }
                },
                is_email_public: { type: :boolean },
                is_gender_public: { type: :boolean },
                is_rel_status_public: { type: :boolean }
              }
            }
          }

        run_test!
      end
    end
  end

  path '/api/v1/profiles/{id}' do
    patch 'Update a specific profile' do
      tags 'Profiles'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter schema: {
        type: :object,
        properties: {
          name: { type: :string },
          surname: { type: :string },
          bio: { type: :string },
          dob: { type: :string, format: :date },
          gender: { type: :string },
          relationship_status: { type: :string },
          is_email_public: { type: :boolean },
          is_gender_public: { type: :boolean },
          is_rel_status_public: { type: :boolean }
        }
      }

      response '200', 'profile updated' do
        schema type: :object,
          properties: {
            data: {
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
                avatar_data: {
                  type: :object,
                  properties: {
                    url: { type: :string, nullable: true }
                  }
                },
                is_email_public: { type: :boolean },
                is_gender_public: { type: :boolean },
                is_rel_status_public: { type: :boolean }
              }
            }
          }

        run_test!
      end
    end
  end


  path '/api/v1/profiles/update_images/{type}' do
    patch 'Update profile images' do
      tags 'Profiles'
      consumes 'multipart/form-data'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :type, in: :path, type: :string, description: 'Image type (avatar, background image)', required: true
      parameter name: :image, in: :formData, schema: {
        type: :object,
        properties: {
          image: { type: :string, format: :binary }
        }
      }

      response '200', 'profile images updated' do
        run_test!
      end
    end
  end

  path '/api/v1/profiles/get_images/{type}/{user_id}' do
    get 'Get profile images' do
      tags 'Profiles'
      produces 'application/json'
      security [ Bearer: [] ]

      parameter name: :type, in: :path, type: :string, description: 'Image type (avatar, background image)', required: true
      parameter name: :user_id, in: :path, type: :integer, description: 'User ID', required: true

      response '200', 'profile images retrieved' do
        run_test!
      end
    end
  end
end
