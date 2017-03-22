class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :completed_at, :created_at
end
