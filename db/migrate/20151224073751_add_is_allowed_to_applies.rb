class AddIsAllowedToApplies < ActiveRecord::Migration
  def change
    add_column :applies, :is_allowed, :boolean
  end
end
