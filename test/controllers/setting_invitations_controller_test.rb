require 'test_helper'

class SettingInvitationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get setting_invitations_index_url
    assert_response :success
  end

end
