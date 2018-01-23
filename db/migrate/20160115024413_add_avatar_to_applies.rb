class AddAvatarToApplies < ActiveRecord::Migration
  def change
    add_column :applies, :gender, :string
    add_attachment :applies, :avatar
  end

  def down
    remove_column :applies, :gender, :string
    remove_attachment :applies, :avatar
  end
end
