ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'support/mailer_helper.rb'
require 'support/sessions_helper.rb'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

module ActiveSupport
  class TestCase
    ActiveRecord::Migration.check_pending!

    before do
      I18n.locale = :cs
      Settings.app.maintenance_mode = false
    end
  end
end
