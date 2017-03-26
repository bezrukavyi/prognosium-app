describe Forecast, type: :model do
  subject { build :forecast }

  context 'association' do
    it { should belong_to :task }
  end
end
