ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'support/mailer_helper.rb'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

I18n.locale = :cs

module ActiveSupport
  class TestCase
    ActiveRecord::Migration.check_pending!
  end
end
