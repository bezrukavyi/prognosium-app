module ForecastAnalysis
  describe McKanzey, type: :value do
    let(:data) { [106.94, 106.82, 106, 106.1] }
    let(:options) { { alpha: 0.3, beta: 0.8, fi: 0.95, period: 3, data: data } }

    subject { McKanzey.new(options) }

    it 'user default value if options blank' do
      [:alpha, :beta, :period, :fi].each do |param|
        options[param] = nil
      end
      subject = McKanzey.new(options)
      [:alpha, :beta, :period, :fi].each do |param|
        expect(subject.send(param)).to eq(McKanzey::PARAMS[param])
      end
    end

    describe '#forecast' do
      before do
        allow(subject).to receive(:predicted_values).and_return([])
      end
      it 'calc forecast' do
        forecast = subject.forecast.map { |value| value.round(3) }
        expect(forecast).to eq([106.94, 100.138, 94.002])
      end
      it 'calc trend and smoothed' do
        subject.forecast
        smoothed = subject.smoothed.map { |value| value.round(3) }
        trend = subject.trend.map { |value| value.round(3) }
        expect(smoothed).to eq([106.94, 103.161, 98.392, 94.341])
        expect(trend).to eq([0, -3.023, -4.39, -4.074])
      end
    end

    it '#deviation_errors' do
      expect(subject.round_deviation_errors).to eq([0.014, 34.363, 146.364])
    end

    it '#error_percent' do
      allow(subject).to receive(:deviation_errors).and_return([100, 2, 30, 12])
      allow(subject).to receive(:data).and_return([21, 2, 1, 12])
      expect(subject.error_percent).to eq(4)
    end

    context 'With file test.xlsx' do
      before do
        file = fixture_file_upload('/files/test.xlsx')
        data = JSON.parse ParseSheetService.call(file, :json)
        options[:data] = data['values']
      end
      it '#forecast' do
        allow(subject).to receive(:calc_forecast).and_return([1, 2, 3])
        expect(subject.visual_forecast).to eq([nil, 1, 2, 3, 101.004, 99.986, 98.969])
      end
      it '#predicted_values' do
        expect(subject.predicted_values).to eq([101.004, 99.986, 98.969])
      end
    end
  end
end
