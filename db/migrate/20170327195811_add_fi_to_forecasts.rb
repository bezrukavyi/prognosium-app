class AddFiToForecasts < ActiveRecord::Migration[5.0]
  def change
    add_column :forecasts, :fi, :float
  end
end
