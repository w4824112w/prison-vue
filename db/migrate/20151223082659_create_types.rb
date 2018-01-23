class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :title
      t.string :notices

      t.timestamps null: false
    end
  end
end
