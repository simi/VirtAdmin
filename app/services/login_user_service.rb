class LoginUserService
  def initialize(user, email=nil)
    @user = user
    @email = email
  end

  def login
    unless @user
      failed
      return :failed
    end

    return :maintenance if Settings.app.maintenance_mode && !@user.admin?
    return :not_approved unless @user.approved?
    return :blocked if @user.blocked?

    successful
    return :successful
  end

  private

  def successful
    UserMailer.login_success(@user).deliver_later
  end

  def failed
    user = User.find_by email: @email
    UserMailer.login_failed(user).deliver_later if user && user.activated? && user.approved?
  end
end
