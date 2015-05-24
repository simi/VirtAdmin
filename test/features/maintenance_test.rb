require 'test_helper'

feature 'Maintenance Mode' do
  include SessionsHelper

  before do
    @user = FactoryGirl.create(:user, password: 'password')
  end

  scenario 'user is logged out when maintenance mode is turned on' do
    login_user @user
    page.must_have_content I18n.t 'sessions.notices.login_successful'
    current_path.must_equal dashboard_path

    Settings.app.maintenance_mode = true
    visit dashboard_path
    page.must_have_content I18n.t 'sessions.notices.logout_maintenance_mode'
    current_path.must_equal maintenance_path
  end
end
