class Verification::Slot < ActiveRecord::Base
  belongs_to :verification_center, class_name: 'Verification::Center', foreign_key: 'verification_center_id'

  validates :starts_at, :ends_at, presence: true
  validate :proper_interval

  private

  def proper_interval
    return unless starts_at && ends_at

    errors.add(:ends_at, I18n.t("ends_at_before_starts_at")) if starts_at >= ends_at
  end
end
