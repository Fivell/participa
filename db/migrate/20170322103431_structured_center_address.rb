class StructuredCenterAddress < ActiveRecord::Migration[5.0]
  def change
    change_table :verification_centers do |t|
      t.rename :address, :street
      t.string :postalcode
      t.string :city
    end
  end
end
