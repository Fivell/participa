require 'test_helper'

class ToolsControllerTest < ActionController::TestCase

  test "should not get index as anonimous" do
    get :index
    assert_response :redirect
  end

  test "should get index as user" do
    sign_in FactoryGirl.create(:user)
    get :index
    assert_response :success
  end

end
