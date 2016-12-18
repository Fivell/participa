require 'test_helper'
require 'integration/concerns/login_helpers'

class PasswordsIntegrationTest < ActionDispatch::IntegrationTest
  include Participa::Test::LoginHelpers

  setup do
    @user = FactoryGirl.create(:user)
    @legacy_password_user = FactoryGirl.create(:user, :legacy_password_user)
  end

  test "should login with password as user" do
    login @user
    assert_logged_in @legacy_password_user
  end

  test "should login with legacy password and change it as legacy_password_user" do
    login @legacy_password_user
    assert_equal new_legacy_password_path(locale: 'es'), current_path
  end

  test "should not have legacy password if legacy_password_user changes it through devise" do
    password = 'lalalilo'
    reset_password_token = @legacy_password_user.send_reset_password_instructions
    put "/es/users/password", params: { user: {reset_password_token: reset_password_token, password: password, password_confirmation: password} } 
    login @legacy_password_user, password
    assert_logged_in @legacy_password_user
  end

  private

  def assert_logged_in(user)
    assert_selector '.header', text: user.full_name
  end
end
