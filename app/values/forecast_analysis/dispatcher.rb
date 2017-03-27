module ForecastAnalysis
  class Dispatcher
    def self.new(options)
      "ForecastAnalysis::#{options[:type].capitalize}".constantize.new(options)
    end
  end
end
