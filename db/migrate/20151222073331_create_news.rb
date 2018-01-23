class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.string :contents
      t.boolean :isFocus
      t.integer :jail_id

      t.timestamps null: false
    end
  end
end
