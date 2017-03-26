include Support::UserAuth
include Support::CheckAttributes
include Support::Projects
include Support::Tasks

feature 'Manage task', type: :feature, js: true do
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

  scenario 'user can delete task' do
    delete_task
    expect(page).to have_content(I18n.t('task.success.deleted',
                                        title: @task.title))
    check_hidden_title(@task, :title, false)
  end

  scenario 'user update title with invalid data' do
    update_title('', :task)
    expect(page).to have_content(I18n.t('validation.required'))
  end

  scenario 'user can update title of task' do
    old_title = @task.title
    new_title = 'Rspec title'
    update_title(new_title, :task)
    exist_hidden_value(new_title)
    exist_hidden_value(old_title, false)
  end
end
