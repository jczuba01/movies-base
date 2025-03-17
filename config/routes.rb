Rails.application.routes.draw do
  get "roles/create"
  get "roles/destroy"
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :actors do
    resources :roles
  end
  resources :directors do
    resources :movies, only: [:index]
  end
  resources :genres do
    resources :movies, only: [:index]
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
          resources :movies, only: [:index]
        end
        resources :genres do
          resources :movies, only: [:index]
        end
        resources :actors
    end
  end

  root "movies#index"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
