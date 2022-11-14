Rails.application.routes.draw do
  devise_for :users

  root 'home#Index'

  resources :posts do
    resources :comments, except: :show
    end
  resources :categories

  get "/:unique_string", to: "posts#short_url"

  namespace :api do
    resources :regions, only: :index, defaults: { format: :json } do
      resources :provinces, only: :index, defaults: { format: :json }
    end
  end
  end
