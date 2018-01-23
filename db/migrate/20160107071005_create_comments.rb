class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :mail_box_id
      t.string :contents
      t.integer :family_id
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
