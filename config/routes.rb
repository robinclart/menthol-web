Rails.application.routes.draw do
  resources :accounts, only: [:show, :update]
  root to: 'accounts#index'

  namespace :api do
    resources :accounts, only: [:create]
  end
end
