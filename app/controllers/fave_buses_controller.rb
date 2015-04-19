class FaveBusesController < ApplicationController

  def index
  end

  def bus_search
    @chosen_bus = params[:q].upcase
    bus_data = HTTParty.get("https://api.wmata.com/Bus.svc/json/jStops?Lat&Lon&Radius&api_key=ff3f1616de1b4f49ab93a499b1bd4bb6")
    @chosen_bus_stops = []
    bus_data["Stops"].each do |stop|
      stop["Routes"].each do |route|
        if route == @chosen_bus
          @chosen_bus_stops << stop["Name"]
        end
      end
    end
  end

  def next_bus
    route_id = params[:bus]
    stop_name = params[:q]

    bus_data = HTTParty.get("https://api.wmata.com/Bus.svc/json/jStops?Lat&Lon&Radius&api_key=ff3f1616de1b4f49ab93a499b1bd4bb6")
    bus_data["Stops"].each do |stop|
      if stop["Name"] == stop_name
        @stop_id = stop["StopID"]
      end
    end

    next_bus_data = HTTParty.get("https://api.wmata.com/NextBusService.svc/json/jPredictions?api_key=ff3f1616de1b4f49ab93a499b1bd4bb6&StopID=#{@stop_id}")
    @next_buses=[]
    next_bus_data["Predictions"].each do |prediction|
      if prediction["RouteID"] == route_id
        direction_name = prediction["DirectionText"]
        minutes_away = prediction["Minutes"]
        @next_buses << {route_id:route_id, stop_id:@stop_id, stop_name:stop_name, direction_name:direction_name, minutes_away:minutes_away}
      end
    end
  end

end
