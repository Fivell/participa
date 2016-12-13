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
    get '/es'
    assert_response :success
  end

  test "should login with legacy password and change it as legacy_password_user" do
    login @legacy_password_user
    get '/es'
    assert_response :redirect
    assert_redirected_to new_legacy_password_path
  end

  test "should not have legacy password if legacy_password_user changes it through devise" do
    password = 'lalalilo'
    reset_password_token = @legacy_password_user.send_reset_password_instructions
    put "/es/users/password", params: { user: {reset_password_token: reset_password_token, password: password, password_confirmation: password} } 
    post_via_redirect user_session_path, 'user[email]' => @legacy_password_user.email, 'user[password]' => password 
    get '/es'
    assert_response :success
  end

end
