require 'test_helper'

class ToolsControllerTest < ActionController::TestCase

  test "should not get index as anonymous" do
    get :index
    assert_response :redirect
  end

  test "should redirect to edit profile when verifications not enabled" do
    with_verifications(false) do
      sign_in create(:user)
      get :index
      assert_response :redirect
      assert_redirected_to edit_user_registration_path
    end
  end

  test "should get index as user when verifications enabled" do
    with_verifications(true) do
      sign_in create(:user)
      get :index
      assert_response :success
    end
  end

  private

  def with_verifications(status)
    prev_status = available_features["verification_presencial"]
    available_features["verification_presencial"] = status

    yield
  ensure
    available_features["verification_presencial"] = prev_status
  end
end
