class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :salt
      t.string :hashed_password
      t.integer :role
      t.integer :jail_id

      t.timestamps null: false
    end
  end
end
