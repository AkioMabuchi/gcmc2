require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_index_url
    assert_response :success
  end

  test "should get show" do
    get users_show_url
    assert_response :success
  end

  test "should get invite_form" do
    get users_invite_form_url
    assert_response :success
  end

  test "should get message_form" do
    get users_message_form_url
    assert_response :success
  end

end
