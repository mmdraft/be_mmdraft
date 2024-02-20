class User < ApplicationRecord
  has_many :user_leagues
  has_many :leagues, through: :user_leagues
  has_many :draft_picks, through: :user_leagues
end
