class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :content
      t.integer :family_id
      t.timestamps null: false
    end
  end
end
