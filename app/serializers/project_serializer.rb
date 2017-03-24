class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :completed_at, :created_at

  has_many :tasks
end
