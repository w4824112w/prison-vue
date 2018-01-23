class CreateFamilies < ActiveRecord::Migration
  def change
    create_table :families do |t|
      t.integer :prisoner_id
      t.string :name
      t.string :uuid
      t.string :phone
      t.string :relationship

      t.timestamps null: false
    end
  end
end
