class AddBarcodeAndUnitToItems < ActiveRecord::Migration
  def change
  	add_column :items, :barcode, :string
  	add_column :items, :unit, :string
  end
end
