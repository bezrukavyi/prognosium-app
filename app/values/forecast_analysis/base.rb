module ForecastAnalysis
  class Base
    attr_reader :forecast, :rounded_forecast, :rounded_deviation_errors,
                :deviation_errors, :error_percent, :predicted_values,
                :forecast_dates

    def initialize(options)
      @data = options[:data]
      @forecast = calc_forecast.unshift(nil)
      @deviation_errors = calc_errors
      @error_percent = calc_mape
    end

    def forecast_dates(dates)
      period.times { |index| dates << (index + 1).to_s }
      dates
    end

    def predicted_values
      calc_predicted_values
    end

    def rounded_forecast
      round_data(forecast)
    end

    def rounded_deviation_errors
      round_data(deviation_errors)
    end

    private

    def calc_forecast
      raise 'Need redefined'
    end

    def calc_errors
      (0...data.size).to_a.map do |index|
        next unless forecast[index]
        (data[index] - forecast[index]).abs
      end
    end

    def calc_mape
      errors = deviation_errors.each_with_index.map do |error, index|
        next if error.nil? || forecast[index].nil?
        error / forecast[index]
      end
      ((errors.compact.sum / forecast.size) * 100).round(3)
    end

    def calc_average(array_data)
      array_data.sum / array_data.size
    end

    def round_data(array_data)
      array_data.map { |value| value.nil? ? value : value.round(3) }
    end

    def calc_predicted_values
      (1..period).to_a.map do |index|
        yield(index)
      end
    end
  end
end
