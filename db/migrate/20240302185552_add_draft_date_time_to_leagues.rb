class AddDraftDateTimeToLeagues < ActiveRecord::Migration[7.1]
  def change
    add_column :leagues, :draft_date_time, :datetime, null: false
  end
end
