class CreateDrawbacks < ActiveRecord::Migration[5.0]
  def change
    create_table :drawbacks do |t|
      t.integer :family_id
      t.decimal :figure, precision: 9, scale: 2

      t.timestamps
    end
  end
end
