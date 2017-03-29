module ForecastAnalysis
  class Holt < Base
    attr_accessor :alpha, :beta, :period, :data, :trend, :smoothed

    PARAMS = { alpha: 0.3, beta: 0.8, period: 3 }.freeze

    def initialize(options)
      super(options, PARAMS)
      @trend = [0]
      @smoothed = [options[:data][0]]
    end

    def visual_forecast
      @visual_forecast ||= super + predicted_values
    end

    private

    def calc_forecast
      calc_trend_smoothed
      forecast_data = []
      (data.size - 1).times.each do |index|
        forecast_data << smoothed[index] + trend[index]
      end
      forecast_data
    end

    def calc_trend_smoothed
      data.size.times do |index|
        next if index.zero?
        prev_smoothed = smoothed[index - 1]
        prev_trend = trend[index - 1]
        smoothed << calc_smoothed(data[index], prev_smoothed, prev_trend)
        trend << calc_trend(smoothed[index], prev_smoothed, prev_trend)
      end
    end

    def calc_smoothed(data_value, prev_smoothed, prev_trend)
      alpha * data_value + (1 - alpha) * (prev_smoothed + prev_trend)
    end

    def calc_trend(smoothed_value, prev_smoothed, prev_trend)
      beta * (smoothed_value - prev_smoothed) + (1 - beta) * prev_trend
    end

    def calc_predicted_values
      calc_trend_smoothed
      super do |index|
        predicted_formula(index)
      end
    end

    def predicted_formula(index)
      smoothed.last + trend.last * index
    end
  end
end
