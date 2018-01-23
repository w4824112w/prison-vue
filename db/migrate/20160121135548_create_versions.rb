class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.string :version_code
      t.integer :version_number

      t.timestamps null: false
    end
  end
end
