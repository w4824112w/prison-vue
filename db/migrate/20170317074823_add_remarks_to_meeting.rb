class AddRemarksToMeeting < ActiveRecord::Migration[5.0]
  def change
    add_column :meetings, :remarks, :string
  end
end
