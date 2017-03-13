require 'test_helper'
require 'integration/concerns/login_helpers'

class PasswordsIntegrationTest < ActionDispatch::IntegrationTest
  include Participa::Test::LoginHelpers

  test "should login with password as user" do
    login create(:user)
    assert_logged_in
  end

  test "should login with password as foreign user" do
    login create(:user, :foreigner)
    assert_logged_in
  end

  private

  def assert_logged_in
    assert_selector '.header', text: 'Cerrar sesión'
  end
end
