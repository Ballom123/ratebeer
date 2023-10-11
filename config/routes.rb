Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  resource :session, only: [:new, :create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root "breweries#index"
  get "all_beers", to: "beers#index"
  post "beers", to: "beers#create"
  get "ratings", to: "ratings#index"
  get "ratings/new", to:"ratings#new"
  post "ratings", to: "ratings#create"
  get "signup", to: "users#new"
  get "signin", to: "sessions#new"
  delete "signout", to: "sessions#destroy"
  get "memberships", to: "memberships#index"
  get "memberships/new", to: "memberships#new"
  post "memberships", to: "memberships#create"
end
