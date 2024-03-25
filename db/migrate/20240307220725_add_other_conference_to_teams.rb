class AddOtherConferenceToTeams < ActiveRecord::Migration[7.1]
  def change
    add_column :teams, :other_conference, :string
  end
end
