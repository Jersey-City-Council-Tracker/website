require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  # --- index ---

  test "index is publicly accessible" do
    get tags_path
    assert_response :success
  end

  test "index displays tags that have agenda items" do
    get tags_path
    assert_response :success
    assert_match "Budget", response.body
    assert_match "Infrastructure", response.body
  end

  test "index does not display tags with no agenda items" do
    get tags_path
    assert_response :success
    assert_no_match "Housing", response.body
  end

  # --- show ---

  test "show is publicly accessible" do
    get tag_path(tags(:budget))
    assert_response :success
  end

  test "show displays tag name and agenda items" do
    get tag_path(tags(:budget))
    assert_response :success
    assert_match "Budget", response.body
    assert_match agenda_items(:ordinance_with_details).title, response.body
  end
end
