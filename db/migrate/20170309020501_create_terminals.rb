class CreateTerminals < ActiveRecord::Migration[5.0]
  def change
    create_table :terminals do |t|
      t.integer :jail_id
      t.string :terminal_number

      t.timestamps
    end
  end
end
