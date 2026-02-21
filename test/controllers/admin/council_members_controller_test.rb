require "test_helper"

class Admin::CouncilMembersControllerTest < ActionDispatch::IntegrationTest
  # --- authorization ---

  test "index as content_admin" do
    sign_in_as(users(:content_admin))
    get admin_council_members_path
    assert_response :success
  end

  test "index as site_admin" do
    sign_in_as(users(:site_admin))
    get admin_council_members_path
    assert_response :success
  end

  test "index as regular_user redirects" do
    sign_in_as(users(:regular_user))
    get admin_council_members_path
    assert_redirected_to root_path
  end

  test "index unauthenticated redirects to login" do
    get admin_council_members_path
    assert_redirected_to new_session_path
  end

  # --- index ---

  test "index shows current and past members" do
    sign_in_as(users(:content_admin))
    get admin_council_members_path
    assert_response :success
    assert_select "td", text: "Mira Ridley"
    assert_select "td", text: "Jane Smith"
  end

  # --- new ---

  test "new as content_admin" do
    sign_in_as(users(:content_admin))
    get new_admin_council_member_path
    assert_response :success
  end

  # --- create ---

  test "create with valid params" do
    sign_in_as(users(:content_admin))

    assert_difference "CouncilMember.count", 1 do
      post admin_council_members_path, params: {
        council_member: {
          first_name: "Amy",
          last_name: "DeGise",
          seat: "at_large",
          term_start: "2025-07-01"
        }
      }
    end

    assert_redirected_to admin_council_members_path
    assert_equal "Council member added.", flash[:notice]
  end

  test "create with invalid params renders new" do
    sign_in_as(users(:content_admin))

    assert_no_difference "CouncilMember.count" do
      post admin_council_members_path, params: {
        council_member: {
          first_name: "",
          last_name: "",
          seat: "",
          term_start: ""
        }
      }
    end

    assert_response :unprocessable_entity
  end

  # --- edit ---

  test "edit as content_admin" do
    sign_in_as(users(:content_admin))
    get edit_admin_council_member_path(council_members(:ridley))
    assert_response :success
  end

  # --- update ---

  test "update with valid params" do
    sign_in_as(users(:content_admin))
    member = council_members(:ridley)

    patch admin_council_member_path(member), params: {
      council_member: { first_name: "Updated" }
    }

    assert_redirected_to admin_council_members_path
    assert_equal "Council member updated.", flash[:notice]
    assert_equal "Updated", member.reload.first_name
  end

  test "update with invalid params renders edit" do
    sign_in_as(users(:content_admin))
    member = council_members(:ridley)

    patch admin_council_member_path(member), params: {
      council_member: { first_name: "" }
    }

    assert_response :unprocessable_entity
  end

  # --- destroy ---

  test "destroy as content_admin" do
    sign_in_as(users(:content_admin))
    member = council_members(:ridley)

    assert_difference "CouncilMember.count", -1 do
      delete admin_council_member_path(member)
    end

    assert_redirected_to admin_council_members_path
    assert_equal "Council member deleted.", flash[:notice]
  end
end
