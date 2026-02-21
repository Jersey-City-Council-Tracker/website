require "test_helper"

class Admin::InvitationsControllerTest < ActionDispatch::IntegrationTest
  test "index as site_admin" do
    sign_in_as(users(:site_admin))
    get admin_invitations_path
    assert_response :success
  end

  test "index as content_admin" do
    sign_in_as(users(:content_admin))
    get admin_invitations_path
    assert_response :success
  end

  test "index as regular user redirects" do
    sign_in_as(users(:regular_user))
    get admin_invitations_path
    assert_redirected_to root_path
  end

  test "new as site_admin" do
    sign_in_as(users(:site_admin))
    get new_admin_invitation_path
    assert_response :success
  end

  test "new as content_admin is denied" do
    sign_in_as(users(:content_admin))
    get new_admin_invitation_path
    assert_redirected_to root_path
  end

  test "create as site_admin" do
    sign_in_as(users(:site_admin))

    assert_difference "Invitation.count", 1 do
      post admin_invitations_path, params: { invitation: { role: "content_admin" } }
    end

    assert_redirected_to admin_invitations_path
  end

  test "create as content_admin is denied" do
    sign_in_as(users(:content_admin))

    assert_no_difference "Invitation.count" do
      post admin_invitations_path, params: { invitation: { role: "content_admin" } }
    end

    assert_redirected_to root_path
  end

  test "destroy as site_admin" do
    sign_in_as(users(:site_admin))
    invitation = invitations(:pending_invitation)

    assert_difference "Invitation.count", -1 do
      delete admin_invitation_path(invitation)
    end

    assert_redirected_to admin_invitations_path
  end

  test "destroy as content_admin is denied" do
    sign_in_as(users(:content_admin))
    invitation = invitations(:pending_invitation)

    assert_no_difference "Invitation.count" do
      delete admin_invitation_path(invitation)
    end

    assert_redirected_to root_path
  end
end
