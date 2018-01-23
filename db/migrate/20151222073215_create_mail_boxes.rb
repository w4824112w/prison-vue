class CreateMailBoxes < ActiveRecord::Migration
  def change
    create_table :mail_boxes do |t|
      t.string :title
      t.string :contents
      t.integer :jail_id
      t.integer :state
      t.timestamps null: false
    end
  end
end
