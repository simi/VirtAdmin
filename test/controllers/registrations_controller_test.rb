require 'test_helper'

describe RegistrationsController do
  include MailerHelper

  before do
    @user = FactoryGirl.create :user
    @user.update_columns activation_state: 'pending', activation_token: Faker::Lorem.characters(15)
  end

  it 'can create new user' do
    password = Faker::Internet.password

    lambda do
      post :create, user: { name: Faker::Name.name, email: Faker::Internet.email, password: password, country: 'CZ' }
    end.must_change 'User.count', +1

    latest_email_subject.must_include I18n.t 'user_mailer.activation_needed.subject'
  end

  it 'activates already registered user' do
    lambda do
      get :activate, id: @user.activation_token
    end.must_change 'ActionMailer::Base.deliveries.count'

    latest_email_subject.must_include I18n.t 'user_mailer.activation_success.subject'
    flash[:notice].must_equal I18n.t 'registrations.notices.activate'
  end

  it 'will not activate user with expired token' do
    travel_to(Time.zone.now + 45.minutes) do
      lambda do
        get :activate, id: @user.activation_token
        flash[:alert].must_equal I18n.t 'registrations.errors.wrong_token'
      end.must_change 'User.count', -1
    end
  end

  it 'sends email when user needs to be approved first' do
    @user.update_column :approved, false

    lambda do
      get :activate, id: @user.activation_token
    end.must_change 'ActionMailer::Base.deliveries.count', +3

    latest_email_subject.must_include I18n.t 'user_mailer.manual_approval_needed.subject'
    flash[:info].must_equal I18n.t 'registrations.notices.manual_approval_needed'
  end

  it 'will not let existing user to register again' do
    @user = FactoryGirl.create :user
    session[:user_id] = @user.id.to_s

    get :new
    flash[:info].must_equal I18n.t 'registrations.notices.already_registered'
  end
end
