Rails.application.routes.draw do
  resources :beers
  resources :breweries
  resources :ratings, only: [:index, :new, :create, :destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")

  root "breweries#index"
  get "all_beers", to: "beers#index"
  get "ratings", to: "ratings#index"
  get "ratings/new", to:"ratings#new"
  post "ratings", to: "ratings#create"
end
