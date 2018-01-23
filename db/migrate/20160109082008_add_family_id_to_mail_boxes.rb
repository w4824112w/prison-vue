class AddFamilyIdToMailBoxes < ActiveRecord::Migration
  def change
    add_column :mail_boxes, :family_id, :integer
  end
end
