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
      it 'rounded_forecast' do
        expect(subject.rounded_forecast).to eq([nil, 106.94, 100.138, 94.002, 90.471, 86.6, 82.729])
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
      expect(subject.rounded_deviation_errors).to eq([nil, 0.12, 5.862, 12.098])
    end

    it '#error_percent' do
      expect(subject.error_percent).to eq(2.691)
    end

    context 'With file test.xlsx' do
      before do
        file = fixture_file_upload('/files/test.xlsx')
        data = JSON.parse ParseSheetService.call(file, :json)
        options[:data] = data['values']
      end
      it '#predicted_values' do
        predicted_values = subject.predicted_values.map { |value| value.round(3) }
        expect(predicted_values).to eq([101.004, 99.986, 98.969])
      end
    end
  end
end
