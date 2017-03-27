module ForecastAnalysis
  class Holt < Base
    attr_reader :alpha, :beta, :period, :data
    attr_accessor :trend, :smoothed

    def initialize(options)
      @alpha = options[:alpha]
      @beta = options[:beta]
      @period = options[:period]
      @data = options[:data]
      @trend = [0]
      @smoothed = [data[0]]
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
        smoothed.last + trend.last * index
      end
    end
  end
end
