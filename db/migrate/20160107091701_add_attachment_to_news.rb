class AddAttachmentToNews < ActiveRecord::Migration
  def change
    add_attachment :news, :image
  end

  def down
    remove_attachment :news, :image
  end
end
