include Support::UserAuth
include Support::CheckAttributes
include Support::Projects
include Support::Tasks

feature 'Create task', type: :feature, js: true do
  let(:user) { create :user, :default_password }

  background do
    @project = create :project, user: user
    sign_in email: user.email
    wait_ajax
    choose_project(@project)
  end

  scenario 'user can create new task' do
    attributes = attributes_for(:task, initial_data: 'files/test.xlsx')
    create_task('new-task-form', attributes)
    expect(page).to have_content(I18n.t('task.success.created', title: attributes[:title]))
    check_hidden_title(Task.last)
  end

  scenario 'when user upload invalid file' do
    attributes = attributes_for(:task, initial_data: 'files/test.txt')
    create_task('new-task-form', attributes)
    expect(page).to have_content(I18n.t('file.invalid', value: 'txt'))
  end

  scenario 'when user write invalid title' do
    attributes = attributes_for(:task, title: nil)
    create_task('new-task-form', attributes)
    expect(page).to have_content(I18n.t('validation.required'))
  end
end
