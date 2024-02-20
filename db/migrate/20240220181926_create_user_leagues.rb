class CreateUserLeagues < ActiveRecord::Migration[7.1]
  def change
    create_table :user_leagues do |t|
      t.references :league, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :manager

      t.timestamps
    end
  end
end
