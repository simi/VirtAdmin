require 'maxminddb'

class ClientInfo
  GEOLITE2_DB = Settings.geolite2.path
  OPERATING_SYSTEMS = { mac: 'OS X', windows: 'Microsoft Windows', linux: 'Linux', other: false }

  attr_accessor :ip_address

  def initialize(ip_address, browser)
    @ip_address = ip_address
    @browser = browser
    @geo_lookup = lookup
  end

  def location
    return false unless @geo_lookup
    separator = city_name.present? && country_name.present? ? ', ' : ''
    "#{city_name}#{separator}#{country_name}"
  end

  def city_name
    @geo_lookup.try(:city).try(:name)
  end

  def country_name
    @geo_lookup.try(:country).try(:name)
  end

  def country_code
    @geo_lookup.try(:country).try(:iso_code)
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
