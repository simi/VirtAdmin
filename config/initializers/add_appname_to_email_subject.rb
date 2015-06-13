class AddAppnameToEmailSubject
  def self.delivering_email(mail)
    prefix = "#{Settings.mail.subject_prefix} "
    mail.subject.prepend(prefix) if mail.subject.present?
  end
end

ActionMailer::Base.register_interceptor(AddAppnameToEmailSubject)
