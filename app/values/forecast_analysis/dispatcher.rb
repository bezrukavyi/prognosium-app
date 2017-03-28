module ForecastAnalysis
  class Dispatcher
    def self.new(options)
      "ForecastAnalysis::#{options[:type].camelize}".constantize.new(options)
    end

    def self.methods_dependencies
      [:brown, :holt, :mc_kanzey].map do |type|
        [type, "ForecastAnalysis::#{type.to_s.camelize}::PARAMS".constantize]
      end.to_h
    end
  end
end
