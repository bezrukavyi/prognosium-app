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

  scenario 'user can delete task' do
    delete_task
    expect(page).to have_content(I18n.t('task.success.deleted',
                                        title: @task.title))
    check_hidden_title(@task, :title, false)
  end
end
