class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :trade_no
      t.integer :jail_id
      t.string :payment_type
      t.string :status

      t.timestamps null: false
    end
  end
end
