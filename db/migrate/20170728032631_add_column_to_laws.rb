class AddColumnToLaws < ActiveRecord::Migration[5.1]
  def change
    add_column :laws, :sys_flag, :integer,:default =>1
  end
end
