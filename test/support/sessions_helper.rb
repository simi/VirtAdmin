module SessionsHelper
  def login_user(user)
    visit login_path
    fill_in I18n.t('attributes.email'), with: user.email
    fill_in I18n.t('attributes.password'), with: 'password'
    click_button I18n.t 'sessions.buttons.log_in'
  end
end
