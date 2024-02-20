class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :seed
      t.string :region
      t.string :conference

      t.timestamps
    end
  end
end
