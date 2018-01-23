class AddDescriptionToVersions < ActiveRecord::Migration[5.0]
  def change
    add_column :versions, :description, :string
  end
end
