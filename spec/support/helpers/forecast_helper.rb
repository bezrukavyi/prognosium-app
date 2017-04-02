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
      choose_analysis_type(options[:analysis_type])
      within "##{form_id}" do
        fill_in 'period', with: options[:period] if options[:period]
        fill_in 'alpha', with: options[:alpha] if options[:alpha]
        fill_in 'beta', with: options[:beta] if options[:beta]
        fill_in 'fi', with: options[:fi] if options[:fi]
      end
    end

    def check_forecast(forecast)
      table_values = forecast.forecast_dates.zip(forecast.analysis.forecast).to_h
      check_forecast_table(table_values)
    end

    def check_forecast_data(data)
      data = JSON.parse data
      table_values = data['dates'].zip(data['values']).to_h
      check_forecast_table(table_values)
    end

    def update_forecast_analysis(form_id, options)
      fill_forecast_params(form_id, options)
      find('#update-forecast').click
      wait_ajax
    end

    def check_forecast_info(info)
      expect(page).to have_content(I18n.t("forecast.method.#{info[:analysis_type]}"))
      %w(alpha beta fi period).each do |attribute|
        next unless info[attribute]
        expect(page).to have_content(info[attribute])
      end
    end

    def choose_analysis_type(type)
      first('.types-select').click
      find("#select-#{type}").click
    end

    private

    def check_forecast_table(table_values)
      table_values.each do |date, value|
        next unless value
        expect(page).to have_content(date)
        expect(page).to have_content(value.round(3))
      end
    end
  end
end
