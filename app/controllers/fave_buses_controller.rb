class FaveBusesController < ApplicationController
  before_action :set_temp

  def index
    @fave_bus_routes = []
    FaveBus.all.each do |fave_bus|
      @fave_bus_routes << {predictions:get_predictions(fave_bus.stop_id, fave_bus.route_id).first, id:fave_bus.id}
    end
  end

  def get_stops
    @chosen_bus = params[:q].upcase
    @stops_for_chosen_bus = get_list_of_stops_for_bus(@chosen_bus)
  end

  def get_next_bus
    stop_name = params[:q]
    bus_name = params[:bus]
    stop_id = get_stop_id(stop_name)
    predictions = get_predictions(stop_id, bus_name)
    @next_buses_on_route = predictions.first
    @other_buses_on_route = predictions.last
  end

  def add_favorite
    favorite_bus = FaveBus.new(route_id:params[:route_id], direction_name:params[:direction_name], stop_id:params[:stop_id], stop_name:params[:stop_name])
    favorite_bus.save!
    redirect_to ('/')
  end

  def destroy
    binding.pry
    fave_bus = FaveBus.find(params[:id])
    fave_bus.destroy
    redirect_to root_path
  end

  private

  def set_temp
    weatherInfo = lookupWeather()
    @temp = weatherInfo[:temp]
    @state = weatherInfo[:state]
    @city = weatherInfo[:city]

  end


end
