class ForecastSerializer < ActiveModel::Serializer
  attributes :id, :initial_data, :alpha, :beta, :period, :analysis_type,
             :support_types

  def support_types
    types = Forecast::TYPES
    types.map { |type| [type, I18n.t("forecast.methods.#{type}")] }.to_h
  end

  def initial_data
    return [] unless object.initial_data
    JSON.parse object.initial_data
  end
end
