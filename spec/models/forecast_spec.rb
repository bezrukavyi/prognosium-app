describe Forecast, type: :model do
  subject { build :forecast }

  context 'association' do
    it { should belong_to :task }
  end

  context 'validation' do
    it do
      %i(alpha period).each do |attribute|
        should validate_presence_of(attribute)
      end
    end
    it do
      should validate_numericality_of(:alpha)
        .is_greater_than_or_equal_to(0)
    end
    it do
      should validate_numericality_of(:alpha)
        .is_less_than_or_equal_to(1)
    end
  end
end
