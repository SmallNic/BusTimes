class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def lookupWeather
    state = "DC"
    city = "Washington"
    cityLookupURL = "http://api.wunderground.com/api/e00b469c839d4b27/conditions/q/" + state + "/" + city + ".json"
    cityData = HTTParty.get(cityLookupURL)
    weatherInfo = {state:state, city:city, temp:cityData["current_observation"]["temp_f"]}
    return weatherInfo
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


end
