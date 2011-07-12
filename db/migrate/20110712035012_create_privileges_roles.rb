class CreatePrivilegesRoles < ActiveRecord::Migration
  def change
    create_table :privileges_roles, :id => false do |t|
      t.references :role
      t.references :privilege

      t.timestamps
    end
  end
end
