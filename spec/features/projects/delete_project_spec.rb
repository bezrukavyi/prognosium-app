include Support::UserAuth
include Support::CheckAttributes
include Support::Projects

feature 'Delete project', type: :feature, js: true do
  let(:user) { create :user, :default_password }

  background do
    @project = create :project, user: user
    sign_in email: user.email
    wait_ajax
    choose_project(@project)
  end

  scenario 'user can delete project' do
    delete_project
    expect(page).to have_content(I18n.t('project.success.deleted',
                                        title: @project.title))
    check_hidden_title(@project, :title, false)
  end
end
