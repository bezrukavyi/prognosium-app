describe User, type: :model do
  subject { build :user }

  context 'association' do
    it { should have_many :projects }
  end
end
