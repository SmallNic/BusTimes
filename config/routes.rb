Rails.application.routes.draw do

  resources :fave_buses

  post '/get_stops', to: 'fave_buses#get_stops'
  post '/get_next_bus', to: 'fave_buses#get_next_bus'
  post '/add_favorite', to: 'fave_buses#add_favorite'
  post '/delete_favorite', to: 'fave_buses#delete_favorite'

  root 'fave_buses#index'

end
