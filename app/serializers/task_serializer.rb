class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :created_at, :comment, :initial_data,
             :project_id
end
