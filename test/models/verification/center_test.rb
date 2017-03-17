require 'test_helper'

class VerificationCenterTest < ActiveSupport::TestCase

  test "#verification_slots includes center (not user) verification slots" do
    center = create(:verification_center, :with_verification_slot)
    user = create(:user, :verifying_presentially, center: center)

    assert_equal 1, center.verification_slots.count
    refute_includes center.verification_slots, user.verification_slots.first
  end

end
