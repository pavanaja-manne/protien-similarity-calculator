require 'test_helper'

class VisualizationControllerTest < ActionController::TestCase
  test "should get time" do
    get :time
    assert_response :success
  end

end
