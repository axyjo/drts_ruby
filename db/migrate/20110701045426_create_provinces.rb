class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|

      t.timestamps
    end
  end
end
