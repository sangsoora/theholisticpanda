require 'test_helper'

class PractitionersControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get practitioners_create_url
    assert_response :success
  end

  test "should get update" do
    get practitioners_update_url
    assert_response :success
  end

  test "should get destroy" do
    get practitioners_destroy_url
    assert_response :success
  end

end
