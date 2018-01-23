class AddAttachmentImageToLaws < ActiveRecord::Migration
  def self.up
    change_table :laws do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :laws, :image
  end
end
