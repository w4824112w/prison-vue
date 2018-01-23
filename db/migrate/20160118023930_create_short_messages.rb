class CreateShortMessages < ActiveRecord::Migration
  def change
    create_table :short_messages do |t|
      t.string :phone
      t.string :uuid
      t.string :code

      t.timestamps null: false
    end
  end
end
