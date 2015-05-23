class AddAppnameToEmailSubject
  def self.delivering_email(mail)
    prefix = "#{Settings.mail.subject_prefix} "
    mail.subject.prepend(prefix)
  end
end

ActionMailer::Base.register_interceptor(AddAppnameToEmailSubject)
