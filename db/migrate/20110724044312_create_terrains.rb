class CreateTerrains < ActiveRecord::Migration
  def change
    create_table :terrains do |t|
      t.string :name
      t.integer :blue_value

      t.timestamps
    end
  end
end
