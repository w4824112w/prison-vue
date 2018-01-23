class AddAttachmentImageToJails < ActiveRecord::Migration
  def self.up
    change_table :jails do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :jails, :image
  end
end
