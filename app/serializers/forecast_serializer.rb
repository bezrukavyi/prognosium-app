class ForecastSerializer < ActiveModel::Serializer
  attributes :id, :initial_data, :alpha, :beta, :period, :analysis_type,
             :support_types, :analysed_data, :deviation_errors, :error_percent,
             :forecast_dates

  def support_types
    types = Forecast::TYPES
    types.map { |type| [type, I18n.t("forecast.methods.#{type}")] }.to_h
  end

  def initial_data
    object.parsed_initial_data
  end
end
