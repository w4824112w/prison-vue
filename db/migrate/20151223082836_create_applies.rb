class CreateApplies < ActiveRecord::Migration
  def change
    create_table :applies do |t|
      t.integer :jail_id
      t.integer :type_id
      t.string :name
      t.string :phone
      t.string :uuid

      t.timestamps null: false
    end
  end
end
