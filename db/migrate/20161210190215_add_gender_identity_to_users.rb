class AddGenderIdentityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gender_identity, :string
  end
end
