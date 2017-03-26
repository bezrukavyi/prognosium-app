class UpdateForecast < Rectify::Command
  attr_reader :forecast, :params, :file

  def initialize(forecast, params)
    @forecast = forecast
    @params = params
    @file = params[:file]
  end

  def call
    return broadcast(:invalid_file, data.file_extname) unless data_valid?
    transactions ? broadcast(:valid) : broadcast(:invalid, forecast)
  end

  private

  def transactions
    transaction do
      set_initial_data
      forecast.update_attributes(forecast_params)
    end
  end

  def data_valid?
    return false if file.blank?
    data.valid?
  end

  def data
    @data ||= ParseSheetService.new(file, :json)
  end

  def set_initial_data
    forecast.initial_data = data.call if file.present?
  end

  def forecast_params
    params.require(:forecast).permit(:alpha, :beta, :period, :task_id)
  end
end
