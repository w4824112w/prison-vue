class AddFamilyIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :family_id, :integer
  end
end
