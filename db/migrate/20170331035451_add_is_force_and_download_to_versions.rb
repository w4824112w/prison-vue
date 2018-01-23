class AddIsForceAndDownloadToVersions < ActiveRecord::Migration[5.0]
  def change
    add_column :versions, :download, :string
    add_column :versions, :is_force, :boolean
  end
end
