Rails.application.routes.draw do

  resources :fave_buses

  post '/bus_search', to: 'fave_buses#bus_search'
  post '/next_bus', to: 'fave_buses#next_bus'

  root 'fave_buses#index'
end
