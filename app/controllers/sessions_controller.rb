class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new
    if Settings.app.maintenance_mode && params[:admin].blank?
      redirect_to maintenance_path
    else
      redirect_to dashboard_path if current_user
    end
  end

  def maintenance
    redirect_to login_path unless Settings.app.maintenance_mode
    redirect_to dashboard_path if current_user
  end

  def create
    @user = login(params[:email], params[:password], params[:remember_me])

    if @user
      if Settings.app.maintenance_mode && !@user.admin?
        logout
        flash[:info] = t 'sessions.errors.maintenance_mode'
        redirect_to maintenance_path
        return
      end

      unless @user.approved?
        logout
        flash[:info] = t 'sessions.errors.not_approved'
        redirect_to login_path
        return
      end

      if @user.blocked?
        logout
        redirect_to login_path, alert: t('sessions.errors.blocked')
        return
      end

      UserMailer.login_success(@user).deliver_later
      redirect_to dashboard_path, notice: t('sessions.notices.login_successful')
    else
      user = User.find_by email: params[:email]
      UserMailer.login_failed(user).deliver_later if user && user.activated? && user.approved?
      redirect_to login_path, alert: t('sessions.errors.wrong_password')
    end
  end

  def destroy
    logout
    flash[:info] = t('sessions.notices.logout_successful')
    redirect_to login_path
  end
end
