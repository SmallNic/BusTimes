class FaveBusesController < ApplicationController
  before_action :set_temp


  def get_list_of_stops_for_bus(chosen_bus)
    all_bus_data = HTTParty.get("https://api.wmata.com/Bus.svc/json/jStops?Lat&Lon&Radius&api_key=ff3f1616de1b4f49ab93a499b1bd4bb6")

    stops_for_chosen_bus = []
    all_bus_data["Stops"].each do |stop|
      stop["Routes"].each do |route|
        if route == chosen_bus
          stops_for_chosen_bus << stop["Name"]
        end
      end
    end

    return stops_for_chosen_bus.uniq
  end

  def index
    @fave_bus_routes = []
    FaveBus.all.each do |fave_bus|
      @fave_bus_routes << get_predictions(fave_bus.stop_id, fave_bus.route_id).first
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

  def delete_favorite
    FaveBus.all.each do |fave_bus|
      if fave_bus.stop_id == params[:stop_id].to_i && fave_bus.route_id == params[:route_id]
        fave_bus.destroy
      end
    end
    redirect_to ('/')
  end

  private

  def set_temp
    @temp = lookupWeather(nil)
  end


end
