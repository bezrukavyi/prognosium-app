include Support::UserAuth
include Support::CheckAttributes
include Support::Projects

feature 'Show project', type: :feature, js: true do
  let(:user) { create :user, :default_password }

  background do
    @projects = create_list(:project, 2, user: user)
    sign_in email: user.email
    wait_ajax
  end

  scenario 'user can show list projects' do
    @projects.each do |project|
      expect(page).to have_content(project.title)
    end
  end

  scenario 'user can choose project' do
    project = @projects.first
    expect(page).to have_no_css('.hidden', text: project.title)
    choose_project(project)
    check_hidden_title(project)
    
  end
end
