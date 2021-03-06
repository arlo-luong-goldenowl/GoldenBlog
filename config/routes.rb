Rails.application.routes.draw do

  require 'sidekiq/web'
  require 'sidekiq-scheduler/web'

  mount Sidekiq::Web => '/sidekiq'

  root   'posts#index'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  delete '/logout',  to: 'sessions#destroy'
  get    '/auth/:provider/callback', to: 'sessions#social_login'
  get    '/auth/failure', to: redirect('/')

  resources :users do
    collection do
      get '/profile/:status', to: 'users#profile', as: 'profile'
      get 'change-password',  to: 'users#change_password'
      post 'update-password', to: 'users#update_password'
    end
  end

  resources :posts do
    resources :comments, only: [:create]
    collection do
      get 'search', to: 'posts#search'
    end
    member do
      post :like_unlike, to: 'likes#like_unlike'
      post :share,       to: 'shares#index'
    end
  end

  namespace :admin do
    get '/', to: redirect('/admin/posts')
    resources :users
    resources :posts
    resources :categories
    resources :comments
  end

  resources :sessions, only: [:create]
end
