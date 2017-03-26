module Support
  module Forecast
    include Support::ParseSheet

    def upload_forecast_data(form_id, path)
      file_path = "#{Rails.root}/spec/fixtures/#{path}"
      within "##{form_id}" do
        attach_file 'file', file_path, visible: :hidden
      end
      wait_ajax
      generate_json_from_file(path)
    end

    def check_forecast_data(forecast)
      forecast = forecast.instance_of?(Object::Forecast) ? forecast.initial_data : forecast
      initial_data = JSON.parse forecast
      table_values = initial_data['dates'].zip(initial_data['values']).to_h
      table_values.each do |date, value|
        expect(page).to have_content(date)
        expect(page).to have_content(value)
      end
    end
  end
end
