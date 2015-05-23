class RegistrationsController < ApplicationController
  skip_before_action :require_login
  before_action :check_current_user

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.password_confirmation = @user.password
    @user.locale = I18n.locale
    @user.approved = !Settings.users.manual_approval

    if @user.save(user_params)
      redirect_to login_path, notice: t('registrations.notices.create')
    else
      render :new
    end
  end

  def activate
    user = User.load_from_activation_token(params[:id])

    unless user
      redirect_to login_path, alert: t('registrations.errors.wrong_token')
      return
    end

    user.activate!

    unless user.approved?
      UserMailer.manual_approval_needed(user).deliver_later
      flash[:info] = t 'registrations.notices.manual_approval_needed'
      redirect_to login_path
      return
    end

    redirect_to login_path, notice: t('registrations.notices.activate')
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :country)
  end

  def check_current_user
    return true unless current_user

    flash[:info] = t('registrations.notices.already_registered')
    redirect_to dashboard_path
  end
end
