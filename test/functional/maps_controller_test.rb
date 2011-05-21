require 'test_helper'

class MapsControllerTest < ActionController::TestCase
  test "should get view" do
    get :view
    assert_response :success
  end

end
