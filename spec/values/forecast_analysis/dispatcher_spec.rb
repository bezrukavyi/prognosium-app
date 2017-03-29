module ForecastAnalysis
  describe Dispatcher, type: :value do
    let(:options) { { alpha: 0.8, beta: 0.3, period: 3, type: :holt } }
    let(:data) { [106.94, 106.82, 106, 106.1] }

    it '.new' do
      expect(ForecastAnalysis::Holt).to receive(:new).with(options)
      Dispatcher.new(options)
    end
    it '.forecast_dependencies' do
      dependencies = Dispatcher.forecast_dependencies
      expect(dependencies[:mc_kanzey]).to eq(ForecastAnalysis::McKanzey::PARAMS.keys)
    end

    it '.optimal_forecast' do
      file = fixture_file_upload('/files/for_brown.xlsx')
      data = JSON.parse ParseSheetService.call(file, :json)
      optimal_forecast = Dispatcher.optimal_forecast(data: data['values'])
      expect(optimal_forecast[:type]).to eq(:brown)
      expect(optimal_forecast[:analysis]).to be_an_instance_of(Brown)
    end
  end
end
