class CreatePrisoners < ActiveRecord::Migration
  def change
    create_table :prisoners do |t|
      t.string :prisoner_number
      t.string :name
      t.string :gender
      t.string :crimes
      t.integer :jail_id
      
      t.date    :prison_term_started_at
      t.date    :prison_term_ended_at
      t.timestamps null: false
    end
  end
end
