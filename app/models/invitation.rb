class Invitation < ApplicationRecord
  enum :role, { content_admin: 1, site_admin: 2 }

  belongs_to :invited_by, class_name: "User"
  belongs_to :accepted_by, class_name: "User", optional: true

  validates :token, presence: true, uniqueness: true
  validates :role, presence: true
  validates :expires_at, presence: true

  before_validation :generate_token, on: :create
  before_validation :set_expiry, on: :create

  scope :pending, -> { where(accepted_at: nil).where("expires_at > ?", Time.current) }
  scope :accepted, -> { where.not(accepted_at: nil) }
  scope :expired, -> { where(accepted_at: nil).where("expires_at <= ?", Time.current) }

  def accepted?
    accepted_at.present?
  end

  def expired?
    !accepted? && expires_at <= Time.current
  end

  def pending?
    !accepted? && expires_at > Time.current
  end

  def accept!(user)
    update!(accepted_by: user, accepted_at: Time.current)
  end

  private

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64(32)
  end

  def set_expiry
    self.expires_at ||= 7.days.from_now
  end
end
