class CreateUuidImages < ActiveRecord::Migration
  def change
    create_table :uuid_images do |t|
      t.integer :apply_id
      t.timestamps null: false
    end
  end
end
