class AddPrisonAreaToPrisons < ActiveRecord::Migration
  def change
    add_column :prisoners, :prison_area, :string
  end
end
