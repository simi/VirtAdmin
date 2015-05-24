class ApplicationController < ActionController::Base
  force_ssl if: :ssl_configured?
  protect_from_forgery with: :exception

  before_action :setup_locale, except: [:change_locale]
  around_action :setup_time_zone
  before_action :require_login, except: [:change_locale, :setup_time_zone]
  before_action :check_maintenance_mode

  def change_locale
    I18n.locale = params[:locale].to_sym
    cookies.permanent[:locale] = params[:locale]
    current_user.change_locale!(params[:locale]) if current_user

    redirect_to :back
  end

  private

  def ssl_configured?
    Rails.env.production? || Rails.env.staging?
  end

  def not_authenticated
    flash[:info] = t 'sessions.errors.login_first'
    redirect_to login_path
  end

  def setup_locale
    I18n.locale = if current_user.try(:locale)
                    cookies[:locale] = current_user.locale
                    current_user.locale.to_sym
                  elsif cookies[:locale].present?
                    cookies[:locale].to_sym
                  else
                    Settings.app.default_locale.to_sym
                  end
  end

  def setup_time_zone(&block)
    time_zone = current_user.try(:time_zone) || Settings.app.default_time_zone
    Time.use_zone(time_zone, &block)
  end

  def check_maintenance_mode
    return true unless current_user
    return true if current_user.admin?
    return true unless Settings.app.maintenance_mode

    logout
    flash[:info] = t 'sessions.notices.logout_maintenance_mode'
    redirect_to maintenance_path
  end
end
