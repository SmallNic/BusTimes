rails g migration CreateUser name:string email:string password_digest:string remember_token:string admin:boolean



rails generate model FaveBus route_id:string direction:integer direction_name:string stop_id: integer stop_name:string  minutes_away:integer


All Bus stops:
https://api.wmata.com/Bus.svc/json/jStops?Lat&Lon&Radius&api_key=ff3f1616de1b4f49ab93a499b1bd4bb6


regex to find portion of stop name


Changing Column Type After Creating Table:
http://stackoverflow.com/questions/17075173/rails-migrations-change-column-with-type-conversion
$ rails g migration ChangeStopIDInFaveBuses
change_column :table_name, :column_name, 'integer USING CAST(column_name AS integer)'


Removing Column From Table
http://stackoverflow.com/questions/2831059/how-to-drop-columns-using-rails-migration
rails generate migration RemoveFieldNameFromTableName field_name:datatype

class RemoveFieldNameFromTableName < ActiveRecord::Migration
  def change
    remove_column :table_name, :field_name, :datatype
  end
end
