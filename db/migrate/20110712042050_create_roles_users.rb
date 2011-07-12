class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users, :id => false do |t|
      t.reference :user
      t.references :role

      t.timestamps
    end
  end
end
