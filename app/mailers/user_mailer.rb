class UserMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def login_success(user)
    @user = user
    mail to: @user.email
  end

  def login_failed(user)
    @user = user
    mail to: @user.email
  end

  def activation_needed(user)
    @user = user
    @activation_url = activate_registration_url(user)
    mail to: @user.email
  end

  def activation_success(user)
    @user = user
    mail to: @user.email
  end

  def manual_approval_admin(user)
    @user = user
    mail to: Settings.mail.admin_address, from: user_to_email(@user)
  end

  def manual_approval_needed(user)
    @user = user
    mail to: @user.email
  end

  def manual_approval_success(user)
    @user = user
    mail to: @user.email
  end

  def manual_approval_denied(user)
    @user = user
    mail to: @user.email
  end

  def reset_password(user)
    @user = user
    @reset_url = edit_reset_password_url(@user.reset_password_token)
    mail to: @user.email
  end

  def new_password(user, client_info, date_time)
    @user = user
    @client_info = client_info
    @date_time = date_time
    mail to: @user.email
  end

  def unlock_token(user)
    @user = user
    mail to: @user.email
  end

  private

  def user_to_email(user)
    "#{user.name} <#{user.email}>"
  end
end
