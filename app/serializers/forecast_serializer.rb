class ForecastSerializer < ActiveModel::Serializer
  attributes :id, :initial_data, :alpha, :beta, :fi, :period, :analysis_type,
             :support_types, :analysed_data, :deviation_errors, :error_percent,
             :forecast_dates

  def support_types
    Forecast::TYPES
  end

  def initial_data
    object.parsed_initial_data
  end
end
