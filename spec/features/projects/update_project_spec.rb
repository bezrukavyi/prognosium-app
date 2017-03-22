include Support::UserAuth
include Support::CheckAttributes
include Support::Projects

feature 'Update project', type: :feature, js: true do
  let(:user) { create :user, :default_password }

  background do
    @project = create :project, user: user
    sign_in email: user.email
    wait_ajax
    choose_project(@project)
  end

  scenario 'user can update title of project' do
    old_title = @project.title
    new_title = 'Rspec title'
    update_project_title(new_title)
    expect(page).to have_content(new_title)
    expect(page).to have_no_content(old_title)
  end

  scenario 'user can update project completed at' do
    old_completed = @project.completed_at
    new_completed = (Time.now + 5.day)
    check_completed_at(old_completed)
    completed_at_project(@project, new_completed)
    check_completed_at(old_completed, false)
    check_completed_at(new_completed)
  end

  scenario 'user update title with invalid data' do
    update_project_title('')
    expect(page).to have_content(I18n.t('validation.required'))
  end
end
