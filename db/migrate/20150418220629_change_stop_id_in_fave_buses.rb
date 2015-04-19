class ChangeStopIdInFaveBuses < ActiveRecord::Migration
  def change
    change_column :fave_buses, :stop_id, 'integer USING CAST(stop_id AS integer)'
  end
end
