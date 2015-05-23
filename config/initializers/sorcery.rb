Rails.application.config.sorcery.submodules = [:remember_me, :user_activation, :reset_password, :activity_logging,
                                               :brute_force_protection]

Rails.application.config.sorcery.configure do |config|
  # config.session_timeout =

  config.user_config do |user|
    user.remember_me_for = 1_209_600

    user.user_activation_mailer = UserMailer
    user.activation_needed_email_method_name = :activation_needed
    user.activation_success_email_method_name = :activation_success
    user.activation_token_expiration_period = 30 * 60 # 30 minutes

    user.reset_password_mailer = UserMailer
    user.reset_password_email_method_name = :reset_password
    user.reset_password_expiration_period = 30 * 60 # 30 minutes
    user.reset_password_time_between_emails = 30 # Seconds

    # How many failed logins allowed.
    # Default: `50`
    #
    # user.consecutive_login_retries_amount_limit =

    # How long the user should be banned. in seconds. 0 for permanent.
    # Default: `60 * 60`
    #
    # user.login_lock_time_period =

    user.unlock_token_email_method_name = :unlock_token
    user.unlock_token_mailer = UserMailer

    # How long since last activity is the user defined logged out?
    # Default: `10 * 60`
    #
    # user.activity_timeout =
  end

  # This line must come after the 'user config' block.
  # Define which model authenticates with sorcery.
  config.user_class = 'User'
end
