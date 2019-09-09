Rails.application.routes.draw do
  root   'pages#index'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  delete '/logout',  to: 'sessions#destroy'
  get    '/auth/:provider/callback', to: 'sessions#social_login'
  get    '/auth/failure', to: redirect('/')

  resources :users do
    collection do
      get 'profile',          to: 'users#profile'
      get 'change-password',  to: 'users#change_password'
      post 'update-password', to: 'users#update_password'
    end
  end

  resources :posts do
    resources :comments, only: [:create]
  end

  resources :sessions, only: [:create]
end
