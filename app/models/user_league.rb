class UserLeague < ApplicationRecord
  belongs_to :user
  belongs_to :league
  has_many :draft_picks
end
