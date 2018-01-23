class AddGmtPaymentToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :gmt_payment, :string
    add_column :orders, :datetime, :string
  end
end
