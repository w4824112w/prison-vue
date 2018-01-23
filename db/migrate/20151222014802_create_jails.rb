class CreateJails < ActiveRecord::Migration
  def change
    create_table :jails do |t|
      t.string :title
      t.string :description
      t.string :street
      t.string :district
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps null: false
    end
  end
end
