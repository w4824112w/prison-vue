class AddFamilyIdToApiKeys < ActiveRecord::Migration
  def change
    add_column :api_keys, :family_id, :integer
  end
end
