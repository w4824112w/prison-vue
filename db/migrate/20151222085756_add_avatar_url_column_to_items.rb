class AddAvatarUrlColumnToItems < ActiveRecord::Migration
  def change
  	add_column :items, :avatar_url, :string
  end
end
