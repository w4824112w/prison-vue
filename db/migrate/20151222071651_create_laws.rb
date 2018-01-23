class CreateLaws < ActiveRecord::Migration
  def change
    create_table :laws do |t|
      t.string :title
      t.string :contents
      t.integer :jail_id

      t.timestamps null: false
    end
  end
end
