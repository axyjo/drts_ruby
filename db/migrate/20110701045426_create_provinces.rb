class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.integer :empire_id
      t.timestamps
    end
  end
end
