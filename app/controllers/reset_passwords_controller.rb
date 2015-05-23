class ResetPasswordsController < ApplicationController
  skip_before_action :require_login
  before_action :find_user, only: [:edit, :update]

  def new
  end

  def edit
  end

  def update
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.change_password!(params[:user][:password])
      client_info = ClientInfo.new(request.remote_ip, browser).serialize
      date_time = l Time.zone.now, format: :short
      UserMailer.new_password(@user, client_info, date_time).deliver_later
      redirect_to login_path, notice: t('reset_passwords.notices.password_changed')
    else
      render :edit
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.activated? && user.approved?
      user.deliver_reset_password_instructions!
      redirect_to login_path, notice: t('reset_passwords.notices.password_sent')
    else
      flash.now[:error] = t 'reset_passwords.errors.wrong_email'
      render :new
    end
  end

  private

  def find_user
    @user = User.load_from_reset_password_token params[:id]
    return true if @user.present?
    redirect_to login_path, alert: t('reset_passwords.errors.wrong_token')
  end
end
