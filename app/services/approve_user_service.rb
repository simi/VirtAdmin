class ApproveUserService
  def initialize(user, ip_address = nil)
    @user = user
    @ip_address = ip_address
  end

  def approve
    if Settings.users.manual_approval.is_a? TrueClass
      disapprove!
      return false
    end

    if Settings.users.manual_approval == 'auto'
      policy = UserApprovablePolicy.new(@user, @ip_address)
      policy.approvable? ? approve! : disapprove!
    else
      approve!
    end

    @user.approved?
  end

  private

  def approve!
    @user.approve!
    Registration.create_from_user @user, @ip_address
  end

  def disapprove!
    @user.disapprove!
    UserMailer.manual_approval_admin(@user).deliver_later
    UserMailer.manual_approval_needed(@user).deliver_later
  end
end
