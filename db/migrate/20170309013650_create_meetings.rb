class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :meetings do |t|
      t.integer :family_id
      t.string :application_date
      t.string :status, default: 'PENDING'
      t.string :meeting_time

      t.timestamps
    end
  end
end
