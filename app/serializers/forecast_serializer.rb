class ForecastSerializer < ActiveModel::Serializer
  attributes :id, :initial_data, :alpha, :beta, :period

  def initial_data
    return [] unless object.initial_data
    JSON.parse object.initial_data
  end
end
