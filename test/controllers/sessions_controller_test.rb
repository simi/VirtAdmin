require 'test_helper'

describe SessionsController do
  include MailerHelper

  before do
    @password = 'somepassword1'
    @user = FactoryGirl.create :user, password: @password, password_confirmation: @password
  end

  let(:log_in) { post :create, email: @user.email, password: @password }

  it 'will not login an unknown user' do
    post :create, email: 'unknown@user.com', password: 'iDontKnow'
    flash[:alert].must_equal I18n.t 'sessions.errors.wrong_password'
    session[:user_id].must_be_nil
  end

  describe 'when user exists' do
    it 'will login with proper credentials' do
      lambda do
        log_in
        flash[:notice].must_equal I18n.t 'sessions.notices.login_successful'
        session[:user_id].wont_be_empty
      end.must_change 'ActionMailer::Base.deliveries.count'

      latest_email_subject.must_include I18n.t 'user_mailer.login_success.subject'
      must_redirect_to dashboard_path
    end

    it 'will not login with wrong password and send warning' do
      lambda do
        post :create, email: @user.email, password: @password + 'error'
        flash[:alert].must_equal I18n.t 'sessions.errors.wrong_password'
        session[:user_id].must_be_nil
      end.must_change 'ActionMailer::Base.deliveries.count'

      latest_email_subject.must_include I18n.t 'user_mailer.login_failed.subject'
    end

    it 'let user logout' do
      session[:user_id] = @user.id
      get :destroy
      session[:user_id].must_be_nil
      must_redirect_to login_path
      flash[:info].must_equal I18n.t 'sessions.notices.logout_successful'
    end

    it 'will not login not yet approved user' do
      @user.update_attribute :approved, false

      log_in
      flash[:info].must_equal I18n.t 'sessions.errors.not_approved'
      session[:user_id].must_be_nil
    end

    it 'will not login not yet activated user' do
      @user.update_attribute :approved, true
      @user.update_attribute :activation_state, 'pending'
      @user.wont_be :activated?

      lambda do
        log_in
        flash[:alert].must_equal I18n.t 'sessions.errors.wrong_password'
        session[:user_id].must_be_nil
      end.wont_change 'ActionMailer::Base.deliveries.count'
    end
  end
end
