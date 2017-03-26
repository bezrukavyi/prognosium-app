class CreateForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :forecasts do |t|
      t.json :initial_data
      t.float :alpha
      t.float :beta
      t.integer :period
      t.integer :analysis_type
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
