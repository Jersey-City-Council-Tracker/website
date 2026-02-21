require "test_helper"

class InvitationTest < ActiveSupport::TestCase
  test "generates token on creation" do
    invitation = Invitation.new(invited_by: users(:site_admin), role: :content_admin)
    assert_nil invitation.token
    invitation.save!
    assert_not_nil invitation.token
    assert invitation.token.length >= 32
  end

  test "sets default expiry to 7 days" do
    invitation = Invitation.create!(invited_by: users(:site_admin), role: :content_admin)
    assert_in_delta 7.days.from_now, invitation.expires_at, 5.seconds
  end

  test "pending scope returns unexpired and unaccepted invitations" do
    pending = Invitation.pending
    assert_includes pending, invitations(:pending_invitation)
    assert_not_includes pending, invitations(:accepted_invitation)
    assert_not_includes pending, invitations(:expired_invitation)
  end

  test "accepted scope returns accepted invitations" do
    accepted = Invitation.accepted
    assert_includes accepted, invitations(:accepted_invitation)
    assert_not_includes accepted, invitations(:pending_invitation)
  end

  test "expired scope returns expired unaccepted invitations" do
    expired = Invitation.expired
    assert_includes expired, invitations(:expired_invitation)
    assert_not_includes expired, invitations(:pending_invitation)
  end

  test "pending? returns true for valid pending invitation" do
    assert invitations(:pending_invitation).pending?
  end

  test "expired? returns true for expired invitation" do
    assert invitations(:expired_invitation).expired?
  end

  test "accepted? returns true for accepted invitation" do
    assert invitations(:accepted_invitation).accepted?
  end

  test "accept! marks invitation as accepted" do
    invitation = invitations(:pending_invitation)
    user = users(:regular_user)

    invitation.accept!(user)

    assert invitation.accepted?
    assert_equal user, invitation.accepted_by
    assert_not_nil invitation.accepted_at
  end
end
