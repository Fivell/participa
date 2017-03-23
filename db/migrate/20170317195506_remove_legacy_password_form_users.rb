class RemoveLegacyPasswordFormUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :has_legacy_password, :boolean
  end
end
