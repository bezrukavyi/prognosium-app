module Support
  module ParseSheet
    def generate_json_from_file(path)
      file = fixture_file_upload("#{Rails.root}/spec/fixtures/#{path}")
      ParseSheetService.call(file, :json)
    end
  end
end
