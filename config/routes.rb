Rails.application.routes.draw do
  # Root path
  root "movies#index"

  # Authentication
  devise_for :users

  # Custom GET routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "roles/create"
  get "roles/destroy"
  get "fetch_movie_details", to: "movies#fetch_details"

  # Main resources
  resources :actors do
    resources :roles
  end

  resources :directors do
    resources :movies, only: [ :index ]
  end

  resources :genres do
    resources :movies, only: [ :index ]
  end

  resources :movies do
    resources :reviews, only: [ :create, :update, :destroy ]
    resources :roles, only: [ :new, :create, :edit, :update, :destroy ]
  end

  # API routes
  namespace :api do
    namespace :v1 do
      resources :movies do
        resources :reviews
        resources :roles
      end

      resources :directors do
        resources :movies, only: [ :index ]
      end

      resources :genres do
        resources :movies, only: [ :index ]
      end

      resources :actors
    end
  end

  # PWA routes (currently commented out)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
