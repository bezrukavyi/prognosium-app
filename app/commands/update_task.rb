class UpdateTask < Rectify::Command
  attr_reader :task, :params

  def initialize(task, params)
    @task = task
    @params = params
  end

  def call
    transactions ? broadcast(:valid) : broadcast(:invalid, task)
  end

  private

  def transactions
    transaction do
      change_position
      task.update_attributes(task_params)
    end
  end

  def change_position
    new_position = params[:task][:position].to_i
    return true if new_position == task.position
    task.set_list_position(new_position)
  end

  def task_params
    params.require(:task).permit(:title, :project_id)
  end
end
