class CreateDraftPicks < ActiveRecord::Migration[7.1]
  def change
    create_table :draft_picks do |t|
      t.references :user_league, null: false, foreign_key: true
      t.integer :round_number
      t.references :team, null: false, foreign_key: true
      t.integer :draft_order

      t.timestamps
    end
  end
end
