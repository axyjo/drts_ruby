class AddTerrainIdToCoordinates < ActiveRecord::Migration
  def change
    add_column :coordinates, :terrain_id, :integer
  end
end
