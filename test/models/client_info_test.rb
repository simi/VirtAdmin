require 'test_helper'

describe ClientInfo do
  describe 'location' do
    before do
      @database_available = File.exist? ClientInfo::GEOLITE2_DB
    end

    it 'returns country based on IPv4 address' do
      skip_db_not_available unless @database_available
      info = ClientInfo.new('77.75.76.3', nil)
      info.location.must_include 'Czech Republic'
      info.country_code.must_equal 'CZ'
    end

    it 'returns country based on IPv6 address' do
      skip_db_not_available unless @database_available
      ClientInfo.new('2001:630:13::1', nil).location.must_include 'United Kingdom'
      ClientInfo.new('2620:0:1b00::1', nil).location.must_include 'United States'
    end

    it 'returns false if IP address does not exist' do
      skip_db_not_available unless @database_available
      ClientInfo.new('127.0.0.1', nil).location.wont_equal true
    end

    private

    def skip_db_not_available
      skip 'MaxMind GeoLite2 database is not available'
    end
  end
end
