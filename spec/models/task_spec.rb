describe Task, type: :model do
  subject { build :task }

  context 'association' do
    it { should belong_to :project }
  end

  context 'validation' do
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(100) }
  end
end
