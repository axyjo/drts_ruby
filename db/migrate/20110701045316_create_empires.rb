class CreateEmpires < ActiveRecord::Migration
  def change
    create_table :empires do |t|

      t.timestamps
    end
  end
end
