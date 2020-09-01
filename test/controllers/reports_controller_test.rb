require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  test "should get openReportEditScreen" do
    get reports_openReportEditScreen_url
    assert_response :success
  end

end
