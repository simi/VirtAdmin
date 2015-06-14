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
    user = login params[:email], params[:password], params[:remember_me]

    case LoginUserService.new(user, params[:email]).login
    when :successful
      redirect_to dashboard_path, notice: t('sessions.notices.login_successful')
    when :failed
      redirect_to login_path, alert: t('sessions.errors.wrong_password')
    when :maintenance
      logout
      flash[:info] = t 'sessions.errors.maintenance_mode'
      redirect_to maintenance_path
    when :blocked
      logout
      redirect_to login_path, alert: t('sessions.errors.blocked')
    when :not_approved
      logout
      flash[:info] = t('sessions.errors.not_approved')
      redirect_to login_path
    else
      redirect_to login_path
    end
  end

  def destroy
    logout
    flash[:info] = t('sessions.notices.logout_successful')
    redirect_to login_path
  end
end
