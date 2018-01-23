class AddMsgToShortMessages < ActiveRecord::Migration
  def change
    add_column :short_messages, :msg, :string
  end
end
