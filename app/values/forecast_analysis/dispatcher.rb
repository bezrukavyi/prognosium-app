module ForecastAnalysis
  class Dispatcher
    TYPES = [:brown, :holt, :mc_kanzey].freeze

    class << self
      def new(options)
        forecast_class(options[:type]).new(options)
      end

      def optimal_forecast(options)
        optimal_analysis = bets_from_forecasts(forecast_results(options))
        { type: optimal_analysis[0], analysis: optimal_analysis[1] }
      end

      def forecast_dependencies
        TYPES.map { |type| [type, forecast_class(type)::PARAMS.keys] }.to_h
      end

      def forecast_class(type)
        "ForecastAnalysis::#{type.to_s.camelize}".constantize
      end

      private

      def forecast_results(options)
        TYPES.map { |type| [type, forecast_class(type).new(options)] }.to_h
      end

      def bets_from_forecasts(forecasts)
        forecasts.min_by { |_type, forecast| forecast.error_percent }
      end
    end
  end
end
