class Team < ApplicationRecord
  validates_presence_of :name, :seed, :region, :conference
  has_many :draft_picks
  has_many :user_leagues, through: :draft_picks
end
