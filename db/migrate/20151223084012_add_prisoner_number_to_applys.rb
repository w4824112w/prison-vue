class AddPrisonerNumberToApplys < ActiveRecord::Migration
  def change
    add_column :applies, :prisoner_number, :string
  end
end
