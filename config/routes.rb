Rails.application.routes.draw do
  devise_for :users

  root 'home#Index'

  resources :posts do
    resources :comments, except: :show
  end

end
