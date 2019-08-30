Rails.application.routes.draw do
  root 'pages#index'
  get '/signup',  to: 'users#new'
  resources :users
end
