require 'test_helper'

feature 'Login' do
  include SessionsHelper

  before do
    @user = FactoryGirl.create(:user, password: 'password')
  end

  scenario 'ordinary visitor is unable to display certain pages without login' do
    visit dashboard_path
    page.must_have_content I18n.t 'sessions.errors.login_first'
    page.must_have_content I18n.t 'sessions.buttons.log_in'
  end

  scenario 'existing user can log in and display dashboard' do
    login_user @user
    page.must_have_content I18n.t 'sessions.notices.login_successful'
    current_path.must_equal dashboard_path
  end
end
