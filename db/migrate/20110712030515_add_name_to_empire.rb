class AddNameToEmpire < ActiveRecord::Migration
  def change
    add_column :empires, :name, :string
  end
end
