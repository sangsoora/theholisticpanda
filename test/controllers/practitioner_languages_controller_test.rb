require 'test_helper'

class PractitionerLanguagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get practitioner_languages_create_url
    assert_response :success
  end

  test "should get destroy" do
    get practitioner_languages_destroy_url
    assert_response :success
  end

end
