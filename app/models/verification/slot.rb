class Verification::Slot < ActiveRecord::Base
  belongs_to :verification_center, class_name: 'Verification::Center', foreign_key: 'verification_center_id'
  belongs_to :user

  validates :starts_at, :ends_at, presence: true
  validate :proper_interval

  scope :active, -> do
    now = Time.zone.now

    where("starts_at <= ? AND ends_at >= ?", now, now)
  end

  scope :past_or_current, -> { where("starts_at <= ?", Time.zone.now) }

  scope :presential, -> { where.not(verification_center: nil) }
  scope :online, -> { where(verification_center: nil) }

  scope :for_center, -> { where(user: nil) }

  def as_opening_time
    "#{I18n.l(starts_at, format: :short)} #{I18n.t("verification.to")} #{I18n.l(ends_at, format: :short)}"
  end

  private

  def proper_interval
    return unless starts_at && ends_at

    errors.add(:ends_at, I18n.t("ends_at_before_starts_at")) if starts_at >= ends_at
  end
end
