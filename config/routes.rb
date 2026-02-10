require "sidekiq/web"
Rails.application.routes.draw do
  mount Rswag::Api::Engine => "/api-docs"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Sidekiq::Web => "/sidekiq"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      devise_for :users,
                 path_names: {
                   sign_in: "sign_in",
                   sign_out: "sign_out",
                   registration: "sign_up"
                 },
                 controllers: {
                   registrations: "api/v1/users/registrations",
                   confirmations: "api/v1/users/confirmations",
                   sessions: "api/v1/users/sessions"
                 },
                 defaults: { format: :json }
      resources :profiles, only: [ :show, :update ] do
        collection do
          get "search/:id", to: "profiles#search"
          patch "update_images/:type", to: "profiles#update_images"
          get "get_images/:type/:user_id", to: "profiles#get_images"
        end
      end
    end
  end
end
