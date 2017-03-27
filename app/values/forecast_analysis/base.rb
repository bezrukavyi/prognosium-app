module ForecastAnalysis
  class Base
    def forecast
      @forecast ||= calc_forecast
      @forecast.compact
    end

    def visual_forecast
      round_data(forecast).unshift(nil)
    end

    def round_deviation_errors
      round_data(deviation_errors)
    end

    def deviation_errors
      @deviation_errors ||= calc_errors
    end

    def error_percent
      @average_error ||= (calc_average(deviation_errors) / calc_average(data)).round(6)
    end

    def predicted_values
      @predicted_values ||= round_data(calc_predicted_values)
    end

    private

    def calc_forecast
      raise 'Need redefined'
    end

    def calc_errors
      (0...forecast.size).to_a.map do |index|
        next unless data[index + 1]
        ((data[index + 1] - forecast[index])**2)
      end.compact
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
