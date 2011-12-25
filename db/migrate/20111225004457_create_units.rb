class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.integer :type
      t.float :speed
      t.float :offence
      t.float :defence
      t.float :morale
      t.float :propensity_to_die
      t.timestamps
    end
  end
end
