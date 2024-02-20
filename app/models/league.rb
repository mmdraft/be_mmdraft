class League < ApplicationRecord
  validates_presence_of :name
  has_many :user_leagues
  has_many :users, through: :user_leagues
end
