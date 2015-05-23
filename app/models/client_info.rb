require 'maxminddb'

class ClientInfo
  GEOLITE2_DB = Settings.geolite2.path
  OPERATING_SYSTEMS = { mac: 'OS X', windows: 'Microsoft Windows', linux: 'Linux', other: false }

  attr_accessor :ip_address

  def initialize(ip_address, browser)
    @ip_address = ip_address
    @browser = browser
  end

  def location
    ret = lookup
    return false unless lookup.found?
    separator = ret.city.name.present? && ret.country.name.present? ? ', ' : ''
    "#{ret.city.name}#{separator}#{ret.country.name}"
  end

  def country_name
    ret = lookup
    return false unless lookup.found?

    ret.country.name.empty? ? false : ret.country.name
  end

  def country_code
    ret = lookup
    return false unless lookup.found?

    ret.country.iso_code.empty? ? false : ret.country.iso_code
  end

  def browser
    return false unless @browser.known?
    @browser.name
  end

  def operating_system
    OPERATING_SYSTEMS[@browser.platform.to_sym]
  end

  def serialize
    { ip_address: ip_address, location: location, browser: browser, operating_system: operating_system }
  end

  private

  def lookup
    return false unless File.exist? GEOLITE2_DB
    MaxMindDB.new(GEOLITE2_DB).lookup ip_address
  end
end
