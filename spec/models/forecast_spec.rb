describe Forecast, type: :model do
  subject { build :forecast, :brown }

  context 'association' do
    it { should belong_to :task }
  end

  context 'validation' do
    it { should validate_presence_of(:analysis_type) }
    it do
      should validate_numericality_of(:alpha)
        .is_greater_than_or_equal_to(0)
    end
    it do
      should validate_numericality_of(:alpha)
        .is_less_than_or_equal_to(1)
    end

    context 'With brown type' do
      subject { build :forecast, :brown }
      it 'valid' do
        expect(subject.valid?).to be_truthy
      end
      it 'invalid' do
        subject.alpha = nil
        expect(subject.valid?).to be_falsey
      end
    end

    context 'With holt type' do
      subject { build :forecast, :holt }
      it 'valid' do
        expect(subject.valid?).to be_truthy
      end
      context 'invalid' do
        it 'without alpha' do
          subject.alpha = nil
          expect(subject.valid?).to be_falsey
        end
        it 'without beta' do
          subject.beta = nil
          expect(subject.valid?).to be_falsey
        end
      end
    end

    context 'With mc_kanzey type' do
      subject { build :forecast, :mc_kanzey }
      it 'valid' do
        expect(subject.valid?).to be_truthy
      end
      context 'invalid' do
        it 'without alpha' do
          subject.alpha = nil
          expect(subject.valid?).to be_falsey
        end
        it 'without beta' do
          subject.beta = nil
          expect(subject.valid?).to be_falsey
        end
        it 'without fi' do
          subject.fi = nil
          expect(subject.valid?).to be_falsey
        end
      end
    end

    context 'Before create .set_optimal_forecast' do
      before do
        file = fixture_file_upload('/files/for_brown.xlsx')
        @data = JSON.parse ParseSheetService.call(file, :json)
      end
      it 'when analysis type blank' do
        forecast_analysis = ForecastAnalysis::Dispatcher.optimal_forecast(data: @data['values'])
        allow_any_instance_of(Forecast).to receive(:optimal_forecast)
          .and_return(forecast_analysis)
        subject = create :forecast, analysis_type: nil
        expect(subject.analysis).to eq(forecast_analysis[:analysis])
        expect(subject.analysis_type).to eq(forecast_analysis[:type].to_s)
      end
      it 'when analysis is exist' do
        subject = create :forecast, :holt
        expect(subject.analysis).to be_an_instance_of(ForecastAnalysis::Holt)
        expect(subject.analysis_type).to eq('holt')
      end
    end
  end
end
