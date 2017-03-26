class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :project_id
end
