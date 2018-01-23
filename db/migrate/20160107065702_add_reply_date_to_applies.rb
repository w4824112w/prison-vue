class AddReplyDateToApplies < ActiveRecord::Migration
  def change
    add_column :applies, :reply_date, :datetime
  end
end
