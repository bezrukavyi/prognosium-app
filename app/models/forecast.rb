class Forecast < ApplicationRecord
  enum analysis_type: ForecastAnalysis::Dispatcher::TYPES

  TYPES = analysis_types.keys

  belongs_to :task

  before_validation :set_optimal_forecast, on: :create

  validates :analysis_type, presence: true
  validates :period, :alpha, :beta, :fi, allow_nil: true, numericality: {
    greater_than_or_equal_to: 0
  }
  validates :alpha, :beta, :fi, allow_nil: true, numericality: { less_than_or_equal_to: 1 }
  validates :period, allow_nil: true, numericality: { less_than_or_equal_to: 5 }

  validates :alpha, required_for: :analysis_type
  validates :beta, :period, required_for: { analysis_type: [:holt, :mc_kanzey] }
  validates :fi, required_for: { analysis_type: [:mc_kanzey] }

  def analysis
    @analysis ||= set_analysis
  end

  def parsed_initial_data
    return [] unless initial_data
    @parsed_initial_data ||= JSON.parse initial_data
  end

  def forecast_dates
    analysis.forecast_dates(parsed_initial_data['dates'])
  end

  def forecast_dependencies
    ForecastAnalysis::Dispatcher.forecast_dependencies
  end

  def optimal_forecast
    ForecastAnalysis::Dispatcher.optimal_forecast(data: parsed_initial_data['values'])
  end

  private

  def set_analysis
    options = { alpha: alpha, beta: beta, fi: fi, period: period,
                type: analysis_type, data: parsed_initial_data['values'] }
    ForecastAnalysis::Dispatcher.new(options)
  end

  def set_optimal_forecast
    return if analysis_type
    forecast = optimal_forecast
    self.analysis_type = forecast[:type]
    @analysis = forecast[:analysis]
    param_from_analisys(@analysis)
  end

  def param_from_analisys(analysis)
    analysis.class::PARAMS.keys.each do |param|
      send("#{param}=", analysis.send(param))
    end
  end
end
