module MailerHelper
  def latest_email_subject
    ActionMailer::Base.deliveries.last[:subject].value
  end
end
