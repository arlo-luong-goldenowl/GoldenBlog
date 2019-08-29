Rails.application.routes.draw do
  root 'pages#index'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  delete '/logout',  to: 'sessions#destroy'

  resources :users, only: [:create] do
    collection do
      get :profile
    end
  end

  resources :sessions, only: [:create, :destroy]
end
