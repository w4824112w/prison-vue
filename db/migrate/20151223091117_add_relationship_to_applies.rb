class AddRelationshipToApplies < ActiveRecord::Migration
  def change
    add_column :applies, :relationship, :string
  end
end
