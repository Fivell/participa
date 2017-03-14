require 'test_helper'
require 'integration/concerns/login_helpers'

class ApplicationIntegrationTest < ActionDispatch::IntegrationTest
  include Participa::Test::LoginHelpers

  setup do
    @user = create(:user)
    @user_foreign = create(:user, :foreigner)
  end

  test "sets locale from default_url_options by default" do
    get '/'
    assert_response :redirect
    assert_redirected_to '/es'
  end

  test "sets locale from url" do
    get '/ca'
    assert_equal(:ca, I18n.locale)
  end

  test "logins successfully for foreign users" do
    @user.update_attribute(:country, "DE")
    @user.update_attribute(:province, "BE")
    @user.update_attribute(:town, nil)
    login @user
    get '/es'
    assert_response :success
  end

  test "logins successfully for rare foreign users (no provinces)" do
    @user.update_attribute(:country, "PS")
    @user.update_attribute(:province, nil)
    @user.update_attribute(:town, nil)
    login @user
    
    get '/es'
    assert_response :success
  end

  if available_features["verification_sms"]
    test "starts sms verification for unconfirmed users, allows access to profile" do
      login @user
      assert_equal sms_validator_step1_path(locale: 'es'), current_path
      assert_text "Por seguridad, debes confirmar tu teléfono."

      click_link 'Datos personales'
      assert_title 'Datos personales'
      assert_equal edit_user_registration_path(locale: 'es'), current_path
    end
  end
end
