require 'test_helper'

feature 'Login' do
  setup do
    @user = FactoryGirl.create(:user, password: 'password')
  end

  scenario 'ordinary visitor is unable to display certain pages without login' do
    visit dashboard_path
    page.must_have_content I18n.t 'sessions.errors.login_first'
    page.must_have_content I18n.t 'sessions.buttons.log_in'
  end

  scenario 'existing user can log in and display dashboard' do
    visit dashboard_path
    fill_in I18n.t('attributes.email'), with: @user.email
    fill_in I18n.t('attributes.password'), with: 'password'
    click_button I18n.t 'sessions.buttons.log_in'

    page.must_have_content I18n.t 'sessions.notices.login_successful'
    current_path.must_equal dashboard_path
  end
end
