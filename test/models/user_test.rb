require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "validates presence of name" do
    user = User.new(name: nil, email_address: "test@example.com", password: "password")
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "validates presence of email_address" do
    user = User.new(name: "Test", email_address: nil, password: "password")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "can't be blank"
  end

  test "validates uniqueness of email_address" do
    existing = users(:site_admin)
    user = User.new(name: "Dup", email_address: existing.email_address, password: "password")
    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "role enum values" do
    assert User.new(role: :user).user?
    assert User.new(role: :content_admin).content_admin?
    assert User.new(role: :site_admin).site_admin?
  end

  test "admin? returns true for site_admin" do
    assert users(:site_admin).admin?
  end

  test "admin? returns true for content_admin" do
    assert users(:content_admin).admin?
  end

  test "admin? returns false for regular user" do
    assert_not users(:regular_user).admin?
  end

  test "default role is user" do
    user = User.new(name: "New", email_address: "new@example.com", password: "password")
    assert user.user?
  end
end
