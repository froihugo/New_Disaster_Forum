Rails.application.routes.draw do

  devise_for :users


  root 'home#Index'

    resources :categories
    resources :posts do
      resources :comments, except: :show
    end
    resources :top_ups, only: [:new, :create]

  get "/:unique_string", to: "posts#short_url"

  constraints(AdminDomainConstraint.new) do
    namespace :admin do
    end
      resources :users
  end

  namespace :api do
    resources :regions, only: :index, defaults: { format: :json } do
      resources :provinces, only: :index, defaults: { format: :json } do
        resources :city_municipalities, only: :index, defaults: { format: :json } do
          resources :barangays, only: :index, defaults: { format: :json }
        end
      end
      resources :districts, only: :index, defaults: { format: :json } do
        resources :city_municipalities, only: :index, defaults: { format: :json } do
          resources :barangays, only: :index, defaults: { format: :json }
        end
      end
    end
  end
end #end
