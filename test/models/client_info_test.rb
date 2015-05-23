require 'test_helper'

describe ClientInfo do
  describe 'location' do
    it 'returns country based on IPv4 address' do
      ClientInfo.new('77.75.76.3', nil).location.must_include 'Czech Republic'
    end

    it 'returns country based on IPv6 address' do
      ClientInfo.new('2001:630:13::1', nil).location.must_include 'United Kingdom'
      ClientInfo.new('2620:0:1b00::1', nil).location.must_include 'United States'
    end

    it 'returns false if IP address does not exist' do
      ClientInfo.new('127.0.0.1', nil).location.wont_equal true
    end
  end
end
