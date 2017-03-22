module Support
  module UserAuth
    def sign_up(form_id, options)
      visit '#!/sign_up'
      within "##{form_id}" do
        fill_in I18n.t('auth.email'), with: options[:email]
        fill_passwords(options[:password])
        click_button I18n.t('auth.sign_up')
      end
    end

    def sign_in(form_id = 'new_session', options)
      options[:password] ||= attributes_for(:user, :default_password)[:password]
      visit '#!/sign_in'
      within "##{form_id}" do
        fill_in I18n.t('auth.email'), with: options[:email]
        fill_in I18n.t('auth.password'), with: options[:password]
        return yield if block_given?
        click_button I18n.t('auth.sign_in')
      end
    end

    def get_confirm_email(email)
      open_email(email)
      current_email.click_link 'Confirm my account'
    end

    private

    def fill_passwords(password, type = 'password')
      fill_in type.capitalize, with: password
      fill_in I18n.t('auth.password_confirmation'), with: password
    end
  end
end
