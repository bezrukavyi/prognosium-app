require 'cancan/matchers'

describe User, type: :model do
  let(:user) { create :user }
  let(:project) { create :project, user: user }
  let(:task) { create :task, project: project }
  subject { Ability.new(user) }

  context 'when user can' do
    it { should be_able_to(:manage, project) }
    it { should be_able_to(:manage, task) }
  end

  context 'when user cant' do
    let(:another_project) { create :project }
    let(:another_task) { create :task }

    it { should_not be_able_to(:manage, another_project) }
    it { should_not be_able_to(:manage, another_task) }
  end
end
