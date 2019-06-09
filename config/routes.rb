Rails.application.routes.draw do
  root to: 'home#index'
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :reviews do
    resources :likes, only: [:create, :destroy]
  end

  resources :users
  resources :reviews, expect: [:index]
  resources :vehicles

  get '/reviews/:user_id/index', to: 'reviews#index'

  get '/likes/create'
  get '/likes/destroy'

  get '/search', to: 'home#search'

  get '/makers', to: 'makers#index'
  get '/makers_ve', to: 'makers#vehicle_form'
end
