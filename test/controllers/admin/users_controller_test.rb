require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "index as site_admin" do
    sign_in_as(users(:site_admin))
    get admin_users_path
    assert_response :success
  end

  test "index as content_admin is denied" do
    sign_in_as(users(:content_admin))
    get admin_users_path
    assert_redirected_to root_path
  end

  test "index as regular user is denied" do
    sign_in_as(users(:regular_user))
    get admin_users_path
    assert_redirected_to root_path
  end
end
