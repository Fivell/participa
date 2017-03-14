require 'test_helper'
require 'integration/concerns/login_helpers'

class ApplicationIntegrationTest < ActionDispatch::IntegrationTest
  include Participa::Test::LoginHelpers

  setup do
    @user = create(:user)
    @user_foreign = create(:user, :foreigner)
  end

  test "should default_url_options locale" do
    get '/'
    assert_response :redirect
    assert_redirected_to '/es'
  end

  test "should set_locale" do
    get '/ca'
    assert_equal(:ca, I18n.locale)
  end

  test "should success when login with a foreign user" do
    @user.update_attribute(:country, "DE")
    @user.update_attribute(:province, "BE")
    @user.update_attribute(:town, nil)
    login @user
    get '/es'
    assert_response :success
  end

  test "should success when login with a rare foreign user (no provinces)" do
    @user.update_attribute(:country, "PS")
    @user.update_attribute(:province, nil)
    @user.update_attribute(:town, nil)
    login @user
    
    get '/es'
    assert_response :success
  end

  if available_features["verification_sms"]
    test "should set_phone if non sms confirmed user, but allow access to profile" do
      login @user
      assert_equal sms_validator_step1_path(locale: 'es'), current_path
      assert_text "Por seguridad, debes confirmar tu teléfono."

      click_link 'Datos personales'
      assert_landed_in_profile_edition
    end
  end

  test "should set_new_password, set_phone and check_born_at, but allow access to profile" do 
    @user.update_attribute(:born_at, Date.civil(1900,1,1))
    @user.update_attribute(:sms_confirmed_at, nil)
    login @user
    assert_text "Debes indicar tu fecha de nacimiento."
    assert_landed_in_profile_edition
  end

  test "should check_born_at if born_at is null" do
    @user.update_attribute(:born_at, nil)
    login @user
    assert_text "Debes indicar tu fecha de nacimiento."
    assert_landed_in_profile_edition
  end

  test "should check_born_at if born_at 1900,1,1" do
    @user.update_attribute(:born_at, Date.civil(1900,1,1))
    login @user
    assert_text "Debes indicar tu fecha de nacimiento."
    assert_landed_in_profile_edition
  end

  test "should not redirect to profile when has invalid profile but no issues" do
    @user.update_attribute(:postal_code, "as")
    login @user
    get '/es'
    assert_response :success
  end

  private

  def assert_landed_in_profile_edition
    assert_title 'Datos personales'
    assert_equal edit_user_registration_path(locale: 'es'), current_path
  end
end
