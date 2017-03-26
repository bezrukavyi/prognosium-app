module Api
  class TasksController < ApplicationController
    load_and_authorize_resource

    def show
      render json: @task, serializer: DetailTaskSerializer
    end

    def create
      CreateTask.call(@task, params) do
        on(:valid) { render json: @task }
        on(:invalid) { |task| render json: { error: task.errors.full_messages } }
        on(:invalid_file) do |file_format|
          render json: { error: I18n.t('file.invalid', value: file_format) }, status: :forbidden
        end
      end
    end

    def update
      UpdateTask.call(@task, params) do
        on(:valid) { render json: @task }
        on(:invalid) { |task| render json: { error: task.errors.full_messages } }
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
      params.require(:task).permit(:title, :project_id)
    end
  end
end
