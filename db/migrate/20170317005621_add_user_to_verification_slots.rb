class AddUserToVerificationSlots < ActiveRecord::Migration[5.0]
  def change
    add_reference :verification_slots, :user, foreign_key: true
  end
end
