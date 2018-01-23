class CreateNewsComments < ActiveRecord::Migration
  def change
    create_table :news_comments do |t|
      t.string :content
      t.integer :family_id
      t.integer :news_id

      t.timestamps null: false
    end
  end
end
