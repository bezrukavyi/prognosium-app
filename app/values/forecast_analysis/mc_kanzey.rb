module ForecastAnalysis
  class McKanzey < Holt
    attr_reader :fi

    def initialize(options)
      super
      @fi = options[:fi]
    end

    def calc_smoothed(data_value, prev_smoothed, prev_trend)
      alpha * data_value + (1 - alpha) * (prev_smoothed + prev_trend) * fi
    end

    def calc_trend(smoothed_value, prev_smoothed, prev_trend)
      beta * (smoothed_value - prev_smoothed) + (1 - beta) * prev_trend * fi
    end

    def predicted_formula(index)
      smoothed.last + trend.last * index * fi
    end
  end
end
