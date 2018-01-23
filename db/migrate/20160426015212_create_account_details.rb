class CreateAccountDetails < ActiveRecord::Migration
  def change
    create_table :account_details do |t|
      t.integer :accounts_id
      t.decimal :amount, precision: 5, scale: 2
      t.string :reason

      t.timestamps null: false
    end
  end
end
