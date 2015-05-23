require 'test_helper'

describe ResetPasswordsController do
  include MailerHelper

  describe 'for existing user' do
    before do
      @user = FactoryGirl.create(:user)
      @new_password = Faker::Internet.password
    end

    it 'will send email with reset instructions' do
      lambda do
        post :create, email: @user.email
      end.must_change 'ActionMailer::Base.deliveries.count'

      latest_email_subject.must_include I18n.t 'user_mailer.reset_password.subject'
      must_respond_with :redirect
      flash[:notice].must_equal I18n.t 'reset_passwords.notices.password_sent'
    end

    it 'will change password with proper token and send email' do
      @user.generate_reset_password_token!

      get :edit, id: @user.reset_password_token
      must_respond_with :success

      patch :update, id: @user.reset_password_token, user: { password: @new_password,
                                                             password_confirmation: @new_password }

      latest_email_subject.must_include I18n.t 'user_mailer.new_password.subject'
      must_respond_with :redirect
      flash[:notice].must_equal I18n.t 'reset_passwords.notices.password_changed'
    end

    it 'will not allow to use expired token' do
      @user.generate_reset_password_token!

      travel_to(Time.zone.now + 45.minutes) do
        patch :update, id: @user.reset_password_token, user: { password: @new_password,
                                                               password_confirmation: @new_password }
        must_respond_with :redirect
        flash[:alert].must_equal I18n.t 'reset_passwords.errors.wrong_token'
      end
    end
  end

  it 'will not allow to use wrong token' do
    wrong_token = Faker::Lorem.characters(25)

    get :edit, id: wrong_token
    must_respond_with :redirect
    flash[:alert].must_equal I18n.t 'reset_passwords.errors.wrong_token'

    patch :update, id: wrong_token
    must_respond_with :redirect
    flash[:alert].must_equal I18n.t 'reset_passwords.errors.wrong_token'
  end

  it 'will show error for non existing user' do
    post :create, email: 'non-existing@email.com'
    must_respond_with :success
    flash[:error].must_equal I18n.t 'reset_passwords.errors.wrong_email'
  end
end
