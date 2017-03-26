module Api
  class ForecastsController < ApplicationController
    load_and_authorize_resource

    def update
      UpdateForecast.call(@forecast, params) do
        on(:valid) { render json: @forecast }
        on(:invalid) { |forecast| render json: { error: forecast.errors.full_messages } }
        on(:invalid_file) do |file_format|
          render json: { error: I18n.t('file.invalid', value: file_format) }, status: :forbidden
        end
      end
    end

    private

    def forecast_params
      params.require(:task).permit(:alpha, :beta, :period, :task_id)
    end
  end
end
