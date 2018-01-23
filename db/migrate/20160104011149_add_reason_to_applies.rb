class AddReasonToApplies < ActiveRecord::Migration
  def change
    add_column :applies, :reason, :string
  end
end
