class RemoveIntegerFromFaveBuses < ActiveRecord::Migration
  def change
    remove_column :fave_buses, :integer, :string
  end
end
