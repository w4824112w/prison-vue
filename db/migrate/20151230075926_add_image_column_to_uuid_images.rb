class AddImageColumnToUuidImages < ActiveRecord::Migration
  def change
  	add_attachment :uuid_images, :image
  end

  def down
  	remove_attachment :uuid_images, :image
  end
end
