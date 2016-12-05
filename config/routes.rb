Rails.application.routes.draw do
  root to: 'accounts#index'

  namespace :api do
    resources :accounts, only: [:create]
  end
end
