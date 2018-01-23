class AddLastTradeToFamily < ActiveRecord::Migration
  def change
    add_column :families, :last_trade_no, :string
  end
end
