class AddFactoryToItems < ActiveRecord::Migration
  def change
    add_column :items, :factory, :string
  end
end
