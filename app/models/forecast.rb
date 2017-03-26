class Forecast < ApplicationRecord
  enum analysis_type: [:brown, :holt]

  TYPES = analysis_types.keys

  ALPHA = 0.5
  BETA = 0.5
  PERIOD = 3

  belongs_to :task
  
  validates :period, presence: true
  validates :alpha, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1
  }
end
