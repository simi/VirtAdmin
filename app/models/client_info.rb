require 'maxminddb'

class ClientInfo
  GEOLITE2_DB = File.join 'lib', 'geolite', 'GeoLite2-City.mmdb'
  OPERATING_SYSTEMS = { mac: 'OS X', windows: 'Microsoft Windows', linux: 'Linux', other: false }

  attr_accessor :ip_address

  def initialize(ip_address, browser)
    @ip_address = ip_address
    @browser = browser
  end

  def location
    return false unless File.exist? GEOLITE2_DB

    ret = MaxMindDB.new(GEOLITE2_DB).lookup ip_address
    return false unless ret.found?

    separator = ret.city.name.present? && ret.country.name.present? ? ', ' : ''
    "#{ret.city.name}#{separator}#{ret.country.name}"
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
end
