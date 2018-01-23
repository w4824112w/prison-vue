class AddJailIdToAcceptApplies < ActiveRecord::Migration
  def change
    add_column :accept_applies, :jail_id, :integer
  end
end
