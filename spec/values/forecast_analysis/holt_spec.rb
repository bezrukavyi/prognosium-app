module ForecastAnalysis
  describe Holt, type: :value do
    let(:data) { [106.94, 106.82, 106, 106.1] }
    let(:options) { { alpha: 0.3, beta: 0.8, period: 3, data: data } }

    subject { Holt.new(options) }

    it 'user default value if options blank' do
      [:alpha, :beta, :period].each do |param|
        options[param] = nil
      end
      subject = Holt.new(options)
      [:alpha, :beta, :period].each do |param|
        expect(subject.send(param)).to eq(Holt::PARAMS[param])
      end
    end

    describe '#forecast' do
      before do
        allow(subject).to receive(:predicted_values).and_return([])
      end
      it 'rounded_forecast' do
        expect(subject.rounded_forecast).to eq([nil, 106.94, 106.875, 106.374, 105.987, 105.683, 105.378])
      end
      it 'calc trend and smoothed' do
        subject.forecast
        smoothed = subject.smoothed.map { |value| value.round(3) }
        trend = subject.trend.map { |value| value.round(3) }
        expect(smoothed).to eq([106.94, 106.904, 106.613, 106.292])
        expect(trend).to eq([0, -0.029, -0.239, -0.305])
      end
    end

    it '#deviation_errors' do
      expect(subject.rounded_deviation_errors).to eq([nil, 0.12, 0.875, 0.274])
    end

    it '#error_percent' do
      expect(subject.error_percent).to eq(0.17)
    end

    context 'With file test.xlsx' do
      before do
        file = fixture_file_upload('/files/test.xlsx')
        data = JSON.parse ParseSheetService.call(file, :json)
        options[:data] = data['values']
      end
      it '#predicted_values' do
        predicted_values = subject.predicted_values.map { |value| value.round(3) }
        expect(predicted_values).to eq([113.547, 112.279, 111.012])
      end
    end

  end
end
