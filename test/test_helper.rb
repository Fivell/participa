ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'simplecov'
require 'webmock/minitest'

require 'support/database_cleaner'

SimpleCov.start
WebMock.disable_net_connect!(allow_localhost: true)
include Warden::Test::Helpers
Warden.test_mode!

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

require 'capybara/rails'
require 'capybara/minitest'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  teardown do
    Capybara.reset_sessions!
  end
end

class JsFeatureTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver
  end

  teardown do
    Capybara.use_default_driver
  end
end

def with_blocked_change_location
  begin
    Rails.application.secrets.users["allows_location_change"] = false
    yield
  ensure
    Rails.application.secrets.users["allows_location_change"] = true
  end
end

def available_features
  Rails.application.secrets.features
end

require 'capybara/poltergeist'

# Poltergeist customization
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, url_whitelist: ['127.0.0.1'])
end

Capybara.javascript_driver = :poltergeist


def with_versioning
  was_enabled = PaperTrail.enabled?
  was_enabled_for_controller = PaperTrail.enabled_for_controller?
  PaperTrail.enabled = true
  PaperTrail.enabled_for_controller = true
  begin
    yield
  ensure
    PaperTrail.enabled = was_enabled
    PaperTrail.enabled_for_controller = was_enabled_for_controller
  end
end
