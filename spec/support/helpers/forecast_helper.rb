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

    def fill_forecast_params(form_id, options)
      within "##{form_id}" do
        fill_in 'period', with: options[:period]
        fill_in 'alpha', with: options[:alpha]
        fill_in 'beta', with: options[:beta]
      end
      choose_analysis_type(options[:analysis_type])
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

    def update_forecast_analysis(form_id, options)
      fill_forecast_params(form_id, options)
      find('#update-forecast').click
    end

    def check_forecast_info(info)
      expect(page).to have_content(I18n.t("forecast.methods.#{info[:analysis_type]}"))
      %w(alpha beta period analysed_data analysed_data error_percent).each do |attribute|
        expect(page).to have_content(info[attribute])
      end
    end

    def choose_analysis_type(type)
      first('.types-select').click
      find("#select-#{type}").click
    end
  end
end
