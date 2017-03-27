class Forecast < ApplicationRecord
  enum analysis_type: [:brown, :holt, :mc_kanzey]

  TYPES = analysis_types.keys

  ALPHA = 0.3
  BETA = 0.8
  FI = 0.95
  PERIOD = 3

  belongs_to :task

  validates :analysis_type, presence: true
  validates :period, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 5
  }
  validates :alpha, :beta, :fi, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 1
  }

  def parsed_initial_data
    return [] unless initial_data
    @parsed_initial_data ||= JSON.parse initial_data
  end

  def forecast_dates
    dates = parsed_initial_data['dates']
    period.times { |index| dates << (index + 1).to_s }
    dates
  end

  def analysis
    options = { alpha: alpha, beta: beta, fi: fi, period: period,
                type: analysis_type, data: parsed_initial_data['values'] }
    @analysis ||= ForecastAnalysis::Dispatcher.new(options)
  end

  def analysed_data
    @analysed_data ||= analysis.visual_forecast
  end

  def deviation_errors
    analysis.round_deviation_errors
  end

  def error_percent
    analysis.error_percent
  end
end
