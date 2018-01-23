class AddRankingToItems < ActiveRecord::Migration
  def change
    add_column :items, :ranking, :integer
  end
end
