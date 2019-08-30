Rails.application.routes.draw do
  root 'pages#index'
  get '/login', to: 'users#new'
  resources :users
end
