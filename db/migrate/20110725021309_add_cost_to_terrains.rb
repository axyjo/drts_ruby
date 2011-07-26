class AddCostToTerrains < ActiveRecord::Migration
  def change
    add_column :terrains, :cost, :float
  end
end
