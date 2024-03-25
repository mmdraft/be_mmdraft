class ChangeRegionAndConferenceToIntegerInTeams < ActiveRecord::Migration[7.1]
  def change
    change_column :teams, :region, 'integer USING CAST(region AS integer)'
    change_column :teams, :conference, 'integer USING CAST(conference AS integer)'
  end
end
