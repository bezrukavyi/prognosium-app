module Api
  class TasksController < ApplicationController
    load_and_authorize_resource

    def show
      render json: @task
    end

    def create
      SaveTask.call(@task, params) do
        on(:valid) { render json: @task }
        on(:invalid) do |task|
          render json: { error: task.errors.full_messages }
        end
        on(:invalid_file) do |file_format|
          render json: { error: I18n.t('file.invalid', value: file_format) },
                 status: :forbidden
        end
      end
    end

    def update
      if change_position && @task.update_attributes(task_params)
        render json: @task
      else
        render json: { error: @task.errors.full_messages }
      end
    end

    def destroy
      if @task.destroy
        render json: @task
      else
        render json: { error: @task.errors.full_messages }
      end
    end

    private

    def task_params
      params.require(:task).permit(:title, :checked, :project_id)
    end

    def change_position
      new_position = params[:task][:position].to_i
      return true if new_position == @task.position
      @task.set_list_position(new_position)
    end
  end
end
