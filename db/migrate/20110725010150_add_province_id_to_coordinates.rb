class AddProvinceIdToCoordinates < ActiveRecord::Migration
  def change
    add_column :coordinates, :province_id, :integer
  end
end
