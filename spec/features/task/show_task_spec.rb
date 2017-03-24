include Support::UserAuth
include Support::CheckAttributes
include Support::Projects
include Support::Tasks

feature 'Show task', type: :feature, js: true do
  let(:user) { create :user, :default_password }
  let(:project) { create :project, :with_tasks, user: user }

  background do
    @task = project.tasks.first
    sign_in email: user.email
    wait_ajax
    choose_task(@task)
  end

  scenario 'user can show one task' do
    check_hidden_title(@task)
    back_to_project
    check_hidden_title(@task.project)
  end
end
