Rails.application.routes.draw do
  root   'pages#index'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  delete '/logout',  to: 'sessions#destroy'
  get    '/auth/:provider/callback', to: 'sessions#social_login'
  get    '/auth/failure', to: redirect('/')

  resources :users, only: [:create, :show] do
    collection do
      get :profile
    end
  end

  resources :posts do
    resources :comments, only: [:create]
    member do
      post :like_unlike, to: 'likes#like_unlike'
    end
  end

  resources :sessions, only: [:create]
end
