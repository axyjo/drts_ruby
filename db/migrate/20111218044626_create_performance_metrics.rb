class CreatePerformanceMetrics < ActiveRecord::Migration
  def change
    create_table :performance_metrics do |t|
      t.datetime :timestamp
      t.string :metric
      t.string :description
      t.integer :value
    end
  end
end
