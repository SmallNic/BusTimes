Rails.application.routes.draw do

  root 'fave_buses#index'

  resources :fave_buses, except: [:show]

  post '/get_stops', to: 'fave_buses#get_stops'
  post '/get_next_bus', to: 'fave_buses#get_next_bus'
  post '/add_favorite', to: 'fave_buses#add_favorite'


end
