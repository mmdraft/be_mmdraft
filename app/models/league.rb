class League < ApplicationRecord
  validates_presence_of :name, :manager_id, :draft_status, :draft_date_time
  enum draft_status: { predraft: 0, in_progress: 1, complete: 2}
  has_many :user_leagues
  has_many :users, through: :user_leagues
end
