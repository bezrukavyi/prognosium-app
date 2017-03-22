include Support::UserAuth

feature 'Sign up', type: :feature, js: true do
  scenario "User haven't account" do
    user_attrs = attributes_for(:user)
    sign_up 'new_user', user_attrs
    expect(page).to have_content I18n.t('auth.success.sign_up')
  end

  scenario 'User use invalid email' do
    user = create :user
    sign_up 'new_user', attributes_for(:user, email: user.email)
    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'User has already authed' do
    user = create :user, :default_password
    sign_in 'new_session', email: user.email
    wait_ajax
    visit '/sign_up'
    expect(page).to have_content I18n.t('auth.error.signed_in')
  end
end
