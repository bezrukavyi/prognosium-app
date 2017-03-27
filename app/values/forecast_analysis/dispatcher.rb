module ForecastAnalysis
  class Dispatcher
    def self.new(options)
      "ForecastAnalysis::#{options[:type].camelize}".constantize.new(options)
    end
  end
end
