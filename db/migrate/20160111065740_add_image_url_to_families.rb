class AddImageUrlToFamilies < ActiveRecord::Migration
  def change
    add_column :families, :image_url, :string
  end
end
