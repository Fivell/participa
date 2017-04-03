class AddNonVisibleIdLabelToOnlineVerificationsLabel < ActiveRecord::Migration[5.0]
  def up
    OnlineVerifications::Label.create(code: 'non_visible_id')
  end

  def down
    ov_label = OnlineVerifications::Label.find_by_code('non_visible_id')
    ov_label.delete
  end
end
