require 'test_helper'

class ToolsControllerTest < ActionController::TestCase

  test "gets index as anonymous" do
    get :index
    assert_response :redirect
  end

  test "redirects to edit profile when no verifications enabled" do
    with_verifications(presential: false, sms: false) do
      sign_in create(:user)
      get :index
      assert_response :redirect
      assert_redirected_to edit_user_registration_path
    end
  end

  test "gets index as user when only presential verifications enabled" do
    with_verifications(presential: true, sms: false) do
      sign_in create(:user)
      get :index
      assert_response :success
    end
  end

  test "redirects to sms verification when only sms verifications enabled" do
    with_verifications(presential: false, sms: true) do
      sign_in create(:user)
      get :index
      assert_response :redirect
      assert_redirected_to sms_validator_step1_path
    end
  end

  test "gets index when only sms verifications enabled & user already verified" do
    with_verifications(presential: false, sms: true) do
      sign_in create(:user, :confirmed_by_sms)
      get :index
      assert_response :success
    end
  end

  test "redirects to sms verification when both verifications enabled & user not verified" do
    with_verifications(presential: true, sms: true) do
      sign_in create(:user)
      get :index
      assert_response :redirect
      assert_redirected_to sms_validator_step1_path
    end
  end

  test "gets index when both verifications enabled & user verified presentially" do
    with_verifications(presential: true, sms: true) do
      sign_in create(:user, :verified_presentially)
      get :index
      assert_response :success
    end
  end

  test "gets index when both verifications enabled & user verified by sms" do
    with_verifications(presential: true, sms: true) do
      sign_in create(:user, :confirmed_by_sms)
      get :index
      assert_response :success
    end
  end
end
