require "test_helper"

class ProfileControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:regular_user)
  end

  test "edit renders for authenticated user" do
    sign_in_as @user
    get edit_profile_path
    assert_response :success
    assert_select "h1", "Edit profile"
  end

  test "edit redirects unauthenticated user to login" do
    get edit_profile_path
    assert_redirected_to new_session_path
  end

  test "update with valid current password updates name and email" do
    sign_in_as @user

    patch profile_path, params: {
      user: {
        name: "Updated Name",
        email_address: "updated@example.com",
        password: "",
        password_confirmation: "",
        current_password: "password"
      }
    }

    assert_redirected_to edit_profile_path
    assert_equal "Profile updated successfully.", flash[:notice]
    @user.reload
    assert_equal "Updated Name", @user.name
    assert_equal "updated@example.com", @user.email_address
  end

  test "update with valid current password updates password" do
    sign_in_as @user

    patch profile_path, params: {
      user: {
        name: @user.name,
        email_address: @user.email_address,
        password: "newsecurepassword",
        password_confirmation: "newsecurepassword",
        current_password: "password"
      }
    }

    assert_redirected_to edit_profile_path
    @user.reload
    assert @user.authenticate("newsecurepassword")
  end

  test "update with wrong current password re-renders with error" do
    sign_in_as @user

    patch profile_path, params: {
      user: {
        name: "Updated Name",
        email_address: @user.email_address,
        password: "",
        password_confirmation: "",
        current_password: "wrongpassword"
      }
    }

    assert_response :unprocessable_entity
    @user.reload
    assert_equal "Regular User", @user.name
  end

  test "update with blank password fields updates only name and email" do
    sign_in_as @user

    patch profile_path, params: {
      user: {
        name: "Just Name Change",
        email_address: @user.email_address,
        password: "",
        password_confirmation: "",
        current_password: "password"
      }
    }

    assert_redirected_to edit_profile_path
    @user.reload
    assert_equal "Just Name Change", @user.name
    assert @user.authenticate("password")
  end

  test "update with invalid email re-renders with errors" do
    sign_in_as @user

    patch profile_path, params: {
      user: {
        name: @user.name,
        email_address: "",
        password: "",
        password_confirmation: "",
        current_password: "password"
      }
    }

    assert_response :unprocessable_entity
    @user.reload
    assert_equal "user@example.com", @user.email_address
  end
end
