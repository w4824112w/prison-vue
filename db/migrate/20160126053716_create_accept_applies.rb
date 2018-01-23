class CreateAcceptApplies < ActiveRecord::Migration
  def change
    create_table :accept_applies do |t|
      t.integer :cloud_message_id
      t.integer :family_id
      t.date :apply_date
      t.datetime :meeting_started
      t.datetime :meeting_finished
      t.string :status

      t.timestamps null: false
    end
  end
end
