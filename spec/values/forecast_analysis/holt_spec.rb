module ForecastAnalysis
  describe Holt, type: :value do
    let(:data) { [106.94, 106.82, 106, 106.1] }
    let(:options) { { alpha: 0.3, beta: 0.8, period: 3, data: data } }

    subject { Holt.new(options) }

    describe '#forecast' do
      before do
        allow(subject).to receive(:predicted_values).and_return([])
      end
      it 'calc forecast' do
        forecast = subject.forecast.map { |value| value.round(3) }
        expect(forecast).to eq([106.94, 106.875, 106.374])
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
      expect(subject.round_deviation_errors).to eq([0.014, 0.766, 0.075])
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
        expect(subject.visual_forecast).to eq([nil, 1, 2, 3, 113.547, 112.279, 111.012])
      end
      it '#predicted_values' do
        expect(subject.predicted_values).to eq([113.547, 112.279, 111.012])
      end
    end

  end
end
