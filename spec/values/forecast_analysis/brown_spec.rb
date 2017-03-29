module ForecastAnalysis
  describe Brown, type: :value do
    let(:data) { [106.94, 106.82, 106, 106.1] }
    let(:options) { { alpha: 0.3, data: data } }

    subject { Brown.new(options) }

    it 'user default value if options blank' do
      options[:alpha] = nil
      subject = Brown.new(options)
      expect(subject.alpha).to eq(Brown::PARAMS[:alpha])
    end

    it '#visual_forecast' do
      expect(subject.visual_forecast).to eq([nil, 106.94, 106.904, 106.633, 106.473])
    end

    it '#round_deviation_errors' do
      expect(subject.round_deviation_errors).to eq([0.014, 0.817, 0.284])
    end

    it '#error_percent' do
      allow(subject).to receive(:deviation_errors).and_return([100, 2, 30, 12])
      allow(subject).to receive(:data).and_return([21, 2, 1, 12])
      expect(subject.error_percent).to eq(4)
    end
  end
end
