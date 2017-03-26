class DetailTaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :created_at, :comment, :project_id

  has_one :forecast
end
