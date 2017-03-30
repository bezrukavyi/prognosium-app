class ForecastSerializer < ActiveModel::Serializer
  attributes :id, :alpha, :beta, :fi, :period, :analysis_type, :support_types,
             :analysis, :forecast_dates, :forecast_dependencies

  def support_types
    Forecast::TYPES
  end
end
