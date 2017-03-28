class Forecast < ApplicationRecord
  enum analysis_type: [:brown, :holt, :mc_kanzey]

  TYPES = analysis_types.keys

  ALPHA = 0.3
  BETA = 0.8
  FI = 0.95
  PERIOD = 3

  belongs_to :task

  validates :analysis_type, presence: true
  validates :period, :alpha, :beta, :fi, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0
  }
  validates :alpha, :beta, :fi, allow_nil: true, numericality: { less_than_or_equal_to: 1 }
  validates :period, allow_nil: true, numericality: { less_than_or_equal_to: 5 }

  validates :alpha, required_for: :analysis_type
  validates :beta, :period, required_for: { analysis_type: [:holt, :mc_kanzey] }
  validates :fi, required_for: { analysis_type: [:mc_kanzey] }

  def parsed_initial_data
    return [] unless initial_data
    @parsed_initial_data ||= JSON.parse initial_data
  end

  def analysis
    options = { alpha: alpha, beta: beta, fi: fi, period: period,
                type: analysis_type, data: parsed_initial_data['values'] }
    @analysis ||= ForecastAnalysis::Dispatcher.new(options)
  end

  def forecast_dates
    analysis.forecast_dates(parsed_initial_data['dates'])
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

  def methods_dependencies
    ForecastAnalysis::Dispatcher.methods_dependencies
  end
end
