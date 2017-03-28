describe RequiredForValidator, type: :validator do
  with_model :MockForecast do
    table do |t|
      t.float :alpha
      t.float :beta
      t.integer :analysis_type
    end

    model do
      enum analysis_type: [:brown, :holt, :mc_kanzey]
      validates :alpha, required_for: :analysis_type
      validates :beta, required_for: { analysis_type: [:holt, :mc_kanzey] }
    end
  end

  subject { MockForecast.new(alpha: 1, beta: 1, analysis_type: :holt) }

  it 'when dependent attribute is blank' do
    subject.alpha = nil
    subject.analysis_type = nil
    expect(subject.valid?).to be_truthy
  end

  context 'When required for attribute' do
    it 'valid' do
      expect(subject.valid?).to be_truthy
    end
    it 'invalid' do
      subject.alpha = nil
      expect(subject.valid?).to be_falsey
    end
  end

  context 'When required for attribute with special values' do
    context 'valid' do
      it 'subject valid' do
        expect(subject.valid?).to be_truthy
      end
      it 'not required value' do
        subject.analysis_type = :brown
        subject.beta = nil
        expect(subject.valid?).to be_truthy
      end
    end
    it 'invalid' do
      subject.beta = nil
      expect(subject.valid?).to be_falsey
    end
  end
end
