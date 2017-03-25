class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :position, :created_at, :comment, :initial_data,
             :project_id

  def initial_data
    return [] unless object.initial_data
    JSON.parse object.initial_data
  end
end
