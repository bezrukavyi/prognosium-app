include Support::Auth
include Support::CanCanStub
include Support::Command
include Support::CanCanStub

describe Api::ForecastsController, type: :controller do
  let(:user) { create :user }
  let(:forecast) { create :forecast }

  before do
    auth_request user
  end

  describe 'PATCH #update' do
    let(:params) do
      { id: forecast.id, forecast: attributes_for(:forecast) }
    end

    before do
      receive_cancan(:load_and_authorize, forecast: forecast)
    end

    it 'CreateTask call' do
      allow(controller).to receive(:params).and_return(params)
      expect(UpdateForecast).to receive(:call)
      patch :update, params: params
    end

    it 'success response by valid command' do
      stub_const('UpdateForecast', Support::Command::Valid)
      patch :update, params: params
      expect(response).to be_success
    end

    it 'error by invalid_file command' do
      stub_const('UpdateForecast', Support::Command::InvalidFile)
      Support::Command::InvalidFile.block_value = 'txt'
      patch :update, params: params
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).to eq I18n.t('file.invalid', value: 'txt')
    end

    it 'error by invalid command' do
      invalid_forecast = build :forecast, :invalid
      invalid_forecast.save
      stub_const('UpdateForecast', Support::Command::Invalid)
      Support::Command::Invalid.block_value = invalid_forecast
      patch :update, params: params
      parsed_response = JSON.parse(response.body)
      expect(parsed_response['error']).not_to be_blank
    end
  end
end
