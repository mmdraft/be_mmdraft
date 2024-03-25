class Team < ApplicationRecord
  MAX_TEAMS = 64
  MAX_SEED = 16

  enum conference: { 'ACC' => 0, 'Big 12' => 1, 'Big East' => 2, 'Big Ten' => 3, 'Pac-12' => 4, 'SEC' => 5, 'American' => 6, 'A-10' => 7, 'MVC' => 8, 'WCC' => 9, 'C-USA' => 10, 'MAC' => 11, 'Mountain West' => 12, 'Sun Belt' => 13, 'CAA' => 14, 'MEAC' => 15, 'SWAC' => 16, 'Other' => 17 }
  enum region: { 'East' => 0, 'West' => 1, 'Midwest' => 2, 'South' => 3 }

  validates :name, presence: true, uniqueness: true
  validates :seed, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: MAX_SEED }
  validates :region, presence: true
  validates :conference, presence: true
  validates :other_conference, presence: true, if: -> { conference == 'Other' }
  validate :validate_max_teams

  has_many :draft_picks, dependent: :restrict_with_error
  has_many :user_leagues, through: :draft_picks
  has_many :leagues, through: :user_leagues

  def actual_conference
    conference == 'Other' ? other_conference : conference
  end

  private

  def validate_max_teams
    errors.add(:base, "Cannot exceed #{MAX_TEAMS} teams") if Team.count >= MAX_TEAMS
  end
end
