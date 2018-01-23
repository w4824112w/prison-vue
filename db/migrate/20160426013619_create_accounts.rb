class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :prisoner_id
      t.decimal :balance, precision: 5, scale: 2

      t.timestamps null: false
    end
  end
end
