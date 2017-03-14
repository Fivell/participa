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

  test "redirects to sms verification when both verifications enabled" do
    with_verifications(presential: true, sms: true) do
      sign_in create(:user)
      get :index
      assert_response :redirect
      assert_redirected_to sms_validator_step1_path
    end
  end

  private

  def with_verifications(presential:, sms:)
    prev_presential = available_features["verification_presencial"]
    prev_sms = available_features["verification_sms"]

    available_features["verification_presencial"] = presential
    available_features["verification_sms"] = sms

    yield
  ensure
    available_features["verification_presencial"] = prev_presential
    available_features["verification_sms"] = prev_sms
  end
end
