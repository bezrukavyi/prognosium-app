module Api
  class ProjectsController < ApplicationController
    load_and_authorize_resource

    def index
      render json: @projects, each_serializer: SimpleProjectSerializer
    end

    def show
      render json: @project
    end

    def update
      if @project.update_attributes(project_params)
        render json: @project
      else
        render json: { error: @project.errors.full_messages }
      end
    end

    def create
      if @project.save
        render json: @project
      else
        render json: { error: @project.errors.full_messages }
      end
    end

    def destroy
      if @project.destroy
        render json: @project
      else
        render json: { error: @project.errors.full_messages }
      end
    end

    private

    def project_params
      params.require(:project).permit(:title, :completed_at)
    end
  end
end
