class CreateConfigurations < ActiveRecord::Migration[5.0]
  def change
    create_table :configurations do |t|
      t.integer :jail_id
      t.integer :meeting_cost
      t.string :am_start_at
      t.string :am_end_at
      t.string :pm_start_at
      t.string :pm_end_at

      t.timestamps
    end
  end
end
