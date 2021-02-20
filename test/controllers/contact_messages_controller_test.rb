require 'test_helper'

class ContactMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get contact_messages_index_url
    assert_response :success
  end

end
