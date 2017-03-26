class Forecast < ApplicationRecord
  enum type: [:brown, :holt]

  ALPHA = 0.5
  BETA = 0.5
  PERIOD = 3

  belongs_to :task
end
