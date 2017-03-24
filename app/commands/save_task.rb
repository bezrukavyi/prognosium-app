class SaveTask < Rectify::Command
  attr_reader :task, :params, :file

  def initialize(task, params)
    @task = task
    @params = params
    @file = params[:file]
  end

  def call
    return broadcast(:invalid, task) unless task.valid?
    return broadcast(:invalid_file, data.file_extname) unless file_valid?
    transaction do
      set_initial_data
      task.save
    end
    broadcast(:valid)
  end

  private

  def file_valid?
    return true if file.blank?
    data.valid?
  end

  def data
    @initial_data ||= ParseSheetService.new(file, :json)
  end

  def set_initial_data
    task.initial_data = data.call if file.present?
  end
end
