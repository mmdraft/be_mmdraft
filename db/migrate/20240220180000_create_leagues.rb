class CreateLeagues < ActiveRecord::Migration[7.1]
  def change
    create_table :leagues do |t|
      t.string :name
      t.integer :manager_id
      t.integer :draft_status

      t.timestamps
    end
  end
end
