class CreateCatalanTowns < ActiveRecord::Migration[5.0]
  def change
    create_table :catalan_towns, id: false do |t|
      t.string :code, primary_key: true
      t.string :name, null: false
      t.integer :comarca_code, null: false
      t.string :comarca_name, null: false
      t.string :amb
      t.string :vegueria_code, null: false
      t.string :vegueria_name, null: false
      t.integer :province_code, null: false
      t.string :province_name, null: false
      t.integer :male_population
      t.integer :female_population
      t.integer :total_population

      t.index :name, unique: true
    end
  end
end
