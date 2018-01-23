class AddBalanceToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :balance, :decimal, precision: 5, scale: 2
  end
end
