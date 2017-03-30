include Support::UserAuth
include Support::CheckAttributes
include Support::Projects
include Support::Tasks
include Support::Forecast

feature 'Manage forecast', type: :feature, js: true do
  let(:user) { create :user, :default_password }
  let(:project) { create :project, user: user }
  let(:task) { create :task, :with_forecast, project: project }

  background do
    @task = task
    @forecast = task.forecast
    sign_in email: user.email
    wait_ajax
  end

  scenario 'user can show forecast info' do
    choose_task(@task)
    check_forecast(@forecast)
  end

  scenario 'user can upload new data by all forecast types' do
    go_to_task(@task)
    Forecast::TYPES.each_with_index do |type, index|
      info = attributes_for(:forecast, type.to_sym)
      fill_forecast_params('forecast-form', info)
      new_data = upload_forecast_data('forecast-form', "files/test_#{index}.xlsx")
      expect(page).to have_content(I18n.t('data.success.updated'))
      check_forecast_info(info)
      check_forecast_data(new_data)
    end
  end

  scenario 'user can update analysis' do
    go_to_task(@task)
    Forecast::TYPES.each do |type|
      info = attributes_for(:forecast, type.to_sym)
      update_forecast_analysis('forecast-form', info)
      check_forecast_info(info)
      check_forecast(@forecast)
    end
  end

  scenario 'when user fill invalid analysis params' do
    go_to_task(@task)
    [:period, :beta, :alpha].each do |attribute|
      info = attributes_for(:forecast, :holt, "#{attribute}": '')
      update_forecast_analysis('forecast-form', info)
      expect(page).to have_content(I18n.t('validation.required'))
    end
  end
end
