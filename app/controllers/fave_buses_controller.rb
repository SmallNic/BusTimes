class FaveBusesController < ApplicationController

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

  def get_predictions(stop_id, bus_name)
    next_bus_data = HTTParty.get("https://api.wmata.com/NextBusService.svc/json/jPredictions?api_key=ff3f1616de1b4f49ab93a499b1bd4bb6&StopID=#{stop_id}")
    stop_name = next_bus_data["StopName"]

    next_buses_on_route=[]
    other_buses_on_route=[]
    next_bus_data["Predictions"].each do |prediction|
      if prediction["RouteID"] == bus_name
        direction_name = prediction["DirectionText"]
        minutes_away = prediction["Minutes"]
        next_buses_on_route << {route_id:bus_name, stop_id:stop_id, stop_name:stop_name, direction_name:direction_name, minutes_away:minutes_away}
      else
        direction_name = prediction["DirectionText"]
        minutes_away = prediction["Minutes"]
        other_buses_on_route << {route_id:prediction["RouteID"], stop_id:stop_id, stop_name:stop_name, direction_name:direction_name, minutes_away:minutes_away}
      end
    end

    return [next_buses_on_route, other_buses_on_route]
  end


  def get_stop_id(stop_name)
    bus_data = HTTParty.get("https://api.wmata.com/Bus.svc/json/jStops?Lat&Lon&Radius&api_key=ff3f1616de1b4f49ab93a499b1bd4bb6")

    bus_data["Stops"].each do |stop|
      if stop["Name"] == stop_name
        return stop["StopID"]
      end
    end
  end

  def index
    zipcodeLookupURL = "http://api.wunderground.com/api/e00b469c839d4b27/geolookup/q/20011.json"
    weatherData = HTTParty.get(zipcodeLookupURL)
    state = weatherData["location"]["state"]
    city = weatherData["location"]["city"]
    cityLookupURL = "http://api.wunderground.com/api/e00b469c839d4b27/conditions/q/" + state + "/" + city + ".json"
    cityData = HTTParty.get(cityLookupURL)
    @temp = cityData["current_observation"]["temp_f"]

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

end
