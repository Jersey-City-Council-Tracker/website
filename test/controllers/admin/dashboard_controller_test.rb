require "test_helper"

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "show as site_admin" do
    sign_in_as(users(:site_admin))
    get admin_dashboard_path
    assert_response :success
  end

  test "show as content_admin" do
    sign_in_as(users(:content_admin))
    get admin_dashboard_path
    assert_response :success
  end

  test "show as regular user redirects" do
    sign_in_as(users(:regular_user))
    get admin_dashboard_path
    assert_redirected_to root_path
  end

  test "show as unauthenticated redirects to login" do
    get admin_dashboard_path
    assert_redirected_to new_session_path
  end
end
