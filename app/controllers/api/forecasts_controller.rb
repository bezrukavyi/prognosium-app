module Api
  class ForecastsController < ApplicationController
    load_and_authorize_resource

    def update
      UpdateForecast.call(@forecast, params) do
        on(:valid) { render json: @forecast }
        on(:invalid) { |forecast| render json: { errors: forecast.errors }, status: :forbidden }
        on(:invalid_file) do |file_format|
          render json: { error: I18n.t('file.invalid', value: file_format) }, status: :forbidden
        end
      end
    end

    private

    def forecast_params
      params.require(:forecast).permit(:alpha, :beta, :fi, :period, :analysis_type, :task_id)
    end
  end
end
