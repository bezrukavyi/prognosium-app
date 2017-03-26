class CreateForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :forecasts do |t|
      t.json :initial_data
      t.integer :alpha
      t.integer :beta
      t.integer :period
      t.integer :type
      t.references :task, foreign_key: true

      t.timestamps
    end
  end
end
