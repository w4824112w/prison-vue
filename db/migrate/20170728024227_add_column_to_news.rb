class AddColumnToNews < ActiveRecord::Migration[5.1]
  def change
    add_column :news, :sys_flag, :integer, :default =>1
  end
end
