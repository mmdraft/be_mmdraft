class DraftPick < ApplicationRecord
  belongs_to :user_league
  belongs_to :team
end
