class UserMailerPreview < ActionMailer::Preview
  def login_success
    UserMailer.login_success User.first
  end

  def login_failed
    UserMailer.login_failed User.first
  end

  def activation_needed
    user = User.first
    user.activation_token = Faker::Lorem.characters 25
    UserMailer.activation_needed user
  end

  def activation_success
    UserMailer.activation_success User.first
  end

  def manual_approval_admin
    UserMailer.manual_approval_admin User.first
  end

  def manual_approval_needed
    UserMailer.manual_approval_needed User.first
  end

  def manual_approval_success
    UserMailer.manual_approval_success User.first
  end

  def manual_approval_denied
    UserMailer.manual_approval_denied User.first
  end

  def reset_password
    user = User.first
    user.reset_password_token = Faker::Lorem.characters 25
    UserMailer.reset_password user
  end

  def new_password
    client_info = { ip_address: '81.31.252.143', location: 'Prague, Czech Republic', browser: 'Opera',
                    operating_system: 'Windows' }
    date_time = Time.zone.now.strftime '%d. %m. %H:%M'
    UserMailer.new_password User.first, client_info, date_time
  end

  def unlock_token
    UserMailer.unlock_token User.first
  end
end
