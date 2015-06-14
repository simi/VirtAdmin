class UserApprovablePolicy
  attr_reader :rejection_reasons

  attr_accessor :suspicious_names
  attr_accessor :suspicious_countries
  attr_accessor :suspicious_ip_addresses
  attr_accessor :suspicious_emails

  def initialize(user, ip_address = nil)
    @user = user
    @user_name = user.name.downcase.strip
    @rejection_reasons = []
    @ip_address = ip_address

    load_default_data
  end

  def approvable?
    @rejection_reasons = []

    @rejection_reasons << :suspicious_name if include_number?
    @rejection_reasons << :suspicious_name if suspicious_name?
    @rejection_reasons << :suspicious_country if suspicious_country?
    @rejection_reasons << :suspicious_ip_address if suspicious_ip_address?
    @rejection_reasons << :suspicious_email if suspicious_email?
    @rejection_reasons << :country_not_match unless country_match?
    @rejection_reasons << :previous_registration if Registration.find_by(email: @user.email)

    @rejection_reasons.count < 1
  end

  def suspicious_countries=(countries)
    @suspicious_countries = countries.map(&:downcase)
  end

  def suspicious_names=(names)
    @suspicious_names = names.map(&:downcase)
  end

  def suspicious_ip_addresses=(ip_addresses)
    @suspicious_ip_addresses = ip_addresses.map(&:downcase)
  end

  def suspicious_emails=(emails)
    @suspicious_emails = emails.map(&:downcase)
  end

  private

  def suspicious_name?
    @suspicious_names.any? { |s| @user_name.include?(s) }
  end

  def suspicious_country?
    @suspicious_countries.include? @user.country.downcase
  end

  def suspicious_ip_address?
    return false if @ip_address.blank?
    @suspicious_ip_addresses.include? @ip_address
  end

  def suspicious_email?
    @suspicious_emails.include? @user.email
  end

  def include_number?
    @user_name =~ /\d/
  end

  def country_match?
    return true unless @ip_address
    client_info = ClientInfo.new @ip_address, nil
    country_code = client_info.country_code
    return true unless country_code

    @user.country.downcase == country_code.downcase
  end

  def load_default_data
    @suspicious_names = default_suspicious_names
    @suspicious_countries = default_suspicious_countries
    @suspicious_ip_addresses = default_suspicious_ip_addresses
    @suspicious_emails = default_suspicious_emails
  end

  def default_suspicious_names
    Settings.users.defaults.suspicious_names.to_a.map(&:downcase)
  end

  def default_suspicious_countries
    Settings.users.defaults.suspicious_countries.to_a.map(&:downcase)
  end

  def default_suspicious_ip_addresses
    Settings.users.defaults.suspicious_ip_addresses.to_a.map(&:downcase)
  end

  def default_suspicious_emails
    Settings.users.defaults.suspicious_emails.to_a.map(&:downcase)
  end
end
