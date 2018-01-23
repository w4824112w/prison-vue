class CreateCloudMessages < ActiveRecord::Migration
  def change
    create_table :cloud_messages do |t|
      t.string :accid
      t.integer :jail_id

      t.timestamps null: false
    end
  end
end
