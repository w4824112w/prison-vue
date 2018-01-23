class CreatePrisonTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :prison_terms do |t|
      t.string :term_start
      t.string :term_finish
      t.integer :prisoner_id

      t.timestamps
    end
  end
end
