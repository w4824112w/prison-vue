class AddAppDateToApplies < ActiveRecord::Migration
  def change
    add_column :applies, :app_date, :date
  end
end
