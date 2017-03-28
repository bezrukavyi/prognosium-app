describe Forecast, type: :model do
  subject { build :forecast }

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
  end
end
