require 'test_helper'

class SettingSkillsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get setting_skills_index_url
    assert_response :success
  end

end
