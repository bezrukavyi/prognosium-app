class ParseSheetService
  attr_reader :file, :type

  SUPPORT_FORMAT = %w(csv xls xlsx).freeze

  def self.call(*args)
    new(*args).call
  end

  def initialize(file, type = :json)
    @file = file
    @type = type
  end

  def call
    return unless valid?
    send("parse_to_#{type}")
  end

  def parse_to_json
    spreed_sheet = read_spreed_sheet
    spreed_sheet.to_json
  end

  def valid?
    SUPPORT_FORMAT.include?(file_extname)
  end

  def file_extname
    @file_extname ||= File.extname(file.original_filename).delete('.')
  end

  private

  def read_spreed_sheet
    spread_sheet = open_spreed_sheet
    header = spread_sheet.row(1)
    table_values = (2..spread_sheet.last_row).map do |row_number|
      row = spread_sheet.row(row_number)
      [row[0], row[1]]
    end.transpose
    { date_title: header[0],
      value_title: header[1],
      dates: table_values[0],
      values: table_values[1] }
  end

  def open_spreed_sheet
    case file_extname
    when 'csv' then Roo::Csv.new(file.path, file_warning: :ignore)
    when 'xls' then Roo::Excel.new(file.path, file_warning: :ignore)
    when 'xlsx' then Roo::Excelx.new(file.path, file_warning: :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
