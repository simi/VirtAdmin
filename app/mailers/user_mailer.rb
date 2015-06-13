class UserMailer < ApplicationMailer
  include Roadie::Rails::Automatic

  def login_success(user)
    @user = user

    I18n.with_locale(@user.locale) do
      mail to: @user.email
    end
  end

  def login_failed(user)
    @user = user

    I18n.with_locale(@user.locale) do
      mail to: @user.email
    end
  end

  def activation_needed(user)
    @user = user
    @activation_url = activate_registration_url(user.activation_token)

    I18n.with_locale(@user.locale) do
      mail to: @user.email
    end
  end

  def activation_success(user)
    @user = user

    I18n.with_locale(@user.locale) do
      mail to: @user.email
    end
  end

  def manual_approval_admin(user)
    @user = user

    emails = Settings.mail.admin_address
    if Settings.mail.to_all_admins
      emails = User.admins.pluck(:email).push emails
    end

    mail to: emails, from: user_to_email(@user)
  end

  def manual_approval_needed(user)
    @user = user

    I18n.with_locale(@user.locale) do
      mail to: @user.email
    end
  end

  def manual_approval_success(user)
    @user = user

    I18n.with_locale(@user.locale) do
      mail to: @user.email
    end
  end

  def manual_approval_denied(user)
    @user = user

    I18n.with_locale(@user.locale) do
      mail to: @user.email
    end
  end

  def reset_password(user)
    @user = user
    @reset_url = edit_reset_password_url(@user.reset_password_token)

    I18n.with_locale(@user.locale) do
      mail to: @user.email
    end
  end

  def new_password(user, client_info, date_time)
    @user = user
    @client_info = client_info
    @date_time = date_time

    I18n.with_locale(@user.locale) do
      mail to: @user.email
    end
  end

  def unlock_token(user)
    @user = user

    I18n.with_locale(@user.locale) do
      mail to: @user.email
    end
  end

  private

  def user_to_email(user)
    "#{user.name} <#{user.email}>"
  end
end
