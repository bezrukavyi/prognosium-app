class CreateTask < Rectify::Command
  attr_reader :task, :params, :file

  def initialize(task, params)
    @task = task
    @params = params
    @file = params[:file]
  end

  def call
    return broadcast(:invalid_file, data.file_extname) unless data_valid?
    transactions ? broadcast(:valid) : broadcast(:invalid, task)
  end

  private

  def data_valid?
    return false if file.blank?
    data.valid?
  end

  def data
    @data ||= ParseSheetService.new(file, :json)
  end

  def transactions
    transaction do
      set_forecast
      block_given? ? yield : task.save
    end
  end

  def set_forecast
    task.forecast = forecast
  end

  def forecast
    options = { initial_data: data.call, period: Forecast::PERIOD,
                alpha: Forecast::ALPHA, beta: Forecast::BETA,
                analysis_type: :brown }
    @forecast = task.build_forecast(options)
  end
end
