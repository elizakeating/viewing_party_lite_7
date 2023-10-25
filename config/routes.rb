# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users, only: [:show]
  get '/users/:id/discover', to: 'movies#index'
  get '/users/:id/movies', to: 'movies#search'
  get '/users/:id/movies/:movie_id', to: 'movies#show'

  root 'welcome#index'
  get '/register/new', to: 'users#new'
  post '/register', to: 'users#create'

  get '/users/:id/movies/:movie_id/viewing_party/new', to: 'viewing_parties#new'
  post '/users/:id/movies/:movie_id/viewing_party', to: 'viewing_parties#create', as: :viewing_party_create

  get '/login', to: "users#login_form", as: :login_form
  post '/login', to: "users#login"
  get '/logout', to: 'users#logout', as: :logout
end
