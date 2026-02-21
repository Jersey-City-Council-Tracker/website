require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "new" do
    get new_session_path
    assert_response :success
  end

  test "create with valid credentials for regular user redirects to root" do
    post session_path, params: { email_address: users(:regular_user).email_address, password: "password" }
    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with valid credentials for admin redirects to admin dashboard" do
    post session_path, params: { email_address: users(:site_admin).email_address, password: "password" }
    assert_redirected_to admin_dashboard_path
    assert cookies[:session_id]
  end

  test "create with invalid credentials" do
    post session_path, params: { email_address: users(:regular_user).email_address, password: "wrong" }
    assert_redirected_to new_session_path
    assert_nil cookies[:session_id]
  end

  test "destroy" do
    sign_in_as(users(:regular_user))

    delete session_path
    assert_redirected_to new_session_path
    assert_empty cookies[:session_id]
  end
end
