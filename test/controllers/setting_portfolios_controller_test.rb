require 'test_helper'

class SettingPortfoliosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get setting_portfolios_index_url
    assert_response :success
  end

  test "should get show" do
    get setting_portfolios_show_url
    assert_response :success
  end

end
