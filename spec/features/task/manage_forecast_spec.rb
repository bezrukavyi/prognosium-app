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
    check_forecast_data(@forecast)
  end

  scenario 'user can upload new data' do
    go_to_task(@task)
    info = attributes_for(:forecast, analysis_type: :holt)
    fill_forecast_params('forecast-form', info)
    new_data = upload_forecast_data('forecast-form', 'files/new_data.xlsx')
    expect(page).to have_content(I18n.t('data.success.updated'))
    check_forecast_info(info)
    check_forecast_data(new_data)
  end

  scenario 'user can update analysis' do
    go_to_task(@task)
    info = attributes_for(:forecast, analysis_type: :holt)
    update_forecast_analysis('forecast-form', info)
    expect(page).to have_content(I18n.t('data.success.updated'))
    check_forecast_info(info)
  end

  scenario 'when user fill invalid analysis params' do
    go_to_task(@task)
    info = attributes_for(:forecast, period: nil)
    fill_forecast_params('forecast-form', info)
    expect(page).to have_content(I18n.t('validation.required'))
  end
end
