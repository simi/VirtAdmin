require 'test_helper'

describe UserApprovablePolicy do
  before do
    @user = FactoryGirl.build :user, name: 'John Doe'
    @database_available = File.exist? ClientInfo::GEOLITE2_DB
  end

  it "won't approve suspicious name" do
    policy = UserApprovablePolicy.new(@user)
    policy.wont_be :approvable?
    policy.rejection_reasons.must_include :suspicious_name

    @user.name = 'Jarom1r Cervenka'
    policy = UserApprovablePolicy.new(@user)
    policy.wont_be :approvable?
    policy.rejection_reasons.must_include :suspicious_name
  end

  it "won't approve suspicious country" do
    policy = UserApprovablePolicy.new(@user)
    policy.suspicious_countries = %w(CZ SK)
    @user.country = 'cz'

    policy.wont_be :approvable?
    policy.rejection_reasons.must_include :suspicious_country
  end

  it "won't approve suspicious email" do
    policy = UserApprovablePolicy.new(@user)
    policy.suspicious_emails = %w(hacker@example.com)
    @user.email = 'hacker@example.com'

    policy.wont_be :approvable?
    policy.rejection_reasons.must_include :suspicious_email
  end

  it "won't approve suspicious ip address" do
    policy = UserApprovablePolicy.new(@user, '127.0.0.1')
    policy.suspicious_ip_addresses = %w(127.0.0.1)

    policy.wont_be :approvable?
    policy.rejection_reasons.must_include :suspicious_ip_address
  end

  it "won't approve when country does not match" do
    skip_db_not_available unless @database_available

    @user.country = 'CZ'
    policy = UserApprovablePolicy.new(@user, '173.194.122.14')

    policy.wont_be :approvable?
    policy.rejection_reasons.must_include :country_not_match
  end

  it "won't approve if registration with same email exists" do
    Registration.create_from_user(@user)
    policy = UserApprovablePolicy.new(@user)

    policy.wont_be :approvable?
    policy.rejection_reasons.must_include :previous_registration
  end

  it 'approves standard name' do
    @user.name = 'Jaromír Červenka'
    UserApprovablePolicy.new(@user).must_be :approvable?

    @user.name = 'Samuel Jackson'
    UserApprovablePolicy.new(@user).must_be :approvable?
  end

  it 'approves country match' do
    @user.name = 'Jaromír Červenka'
    @user.country = 'CZ'

    UserApprovablePolicy.new(@user, '77.75.76.3').must_be :approvable?

    @user.country = 'US'
    UserApprovablePolicy.new(@user, '173.194.122.14').must_be :approvable?
  end

  it "approves if we don't have country" do
    @user.name = 'Jaromír Červenka'
    @user.country = 'CZ'
    UserApprovablePolicy.new(@user, '127.0.0.1').must_be :approvable?
  end

  private

  def skip_db_not_available
    skip 'MaxMind GeoLite2 database is not available'
  end
end
