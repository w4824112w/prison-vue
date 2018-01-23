class AddStatusToDrawbacks < ActiveRecord::Migration[5.0]
  def change
    add_column :drawbacks, :status, :string
  end
end
