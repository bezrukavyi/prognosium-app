require 'cancan/matchers'

describe User, type: :model do
  let(:user) { create :user }
  let(:project) { create :project, user: user }
  subject { Ability.new(user) }

  context 'when user can' do
    it { should be_able_to(:manage, project) }
  end

  context 'when user cant' do
    let(:another_project) { create :project }

    it { should_not be_able_to(:manage, another_project) }
  end
end
