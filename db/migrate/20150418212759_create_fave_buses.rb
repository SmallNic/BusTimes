class CreateFaveBuses < ActiveRecord::Migration
  def change
    create_table :fave_buses do |t|
      t.string :route_id
      t.integer :direction
      t.string :direction_name
      t.string :stop_id
      t.string :integer
      t.string :stop_name
      t.integer :minutes_away

      t.timestamps null: false
    end
  end
end
