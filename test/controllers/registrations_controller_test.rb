require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new with valid token shows registration form" do
    invitation = invitations(:pending_invitation)
    get new_registration_path(token: invitation.token)
    assert_response :success
  end

  test "new with invalid token redirects" do
    get new_registration_path(token: "invalid")
    assert_redirected_to root_path
    assert_equal "Invalid invitation link.", flash[:alert]
  end

  test "new with expired token redirects" do
    invitation = invitations(:expired_invitation)
    get new_registration_path(token: invitation.token)
    assert_redirected_to root_path
    assert_equal "This invitation has expired.", flash[:alert]
  end

  test "new with accepted token redirects" do
    invitation = invitations(:accepted_invitation)
    get new_registration_path(token: invitation.token)
    assert_redirected_to root_path
    assert_equal "This invitation has already been used.", flash[:alert]
  end

  test "create with valid token and params creates user" do
    invitation = invitations(:pending_invitation)

    assert_difference "User.count", 1 do
      post registration_path(token: invitation.token), params: {
        user: {
          name: "New Admin",
          email_address: "newadmin@example.com",
          password: "securepassword",
          password_confirmation: "securepassword"
        }
      }
    end

    user = User.find_by(email_address: "newadmin@example.com")
    assert user.content_admin?
    assert invitation.reload.accepted?
    assert_equal user, invitation.accepted_by
    assert_redirected_to root_path
    assert cookies[:session_id]
  end

  test "create with invalid params re-renders form" do
    invitation = invitations(:pending_invitation)

    assert_no_difference "User.count" do
      post registration_path(token: invitation.token), params: {
        user: {
          name: "",
          email_address: "newadmin@example.com",
          password: "securepassword",
          password_confirmation: "securepassword"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "create assigns role from invitation not from params" do
    invitation = invitations(:pending_invitation)

    post registration_path(token: invitation.token), params: {
      user: {
        name: "New Admin",
        email_address: "newadmin2@example.com",
        password: "securepassword",
        password_confirmation: "securepassword",
        role: "site_admin"
      }
    }

    user = User.find_by(email_address: "newadmin2@example.com")
    assert user.content_admin?
    assert_not user.site_admin?
  end
end
