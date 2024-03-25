require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }

    it { should validate_presence_of(:seed) }
    it { should validate_numericality_of(:seed).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(Team::MAX_SEED) }

    it { should validate_presence_of(:region) }
    it { should validate_presence_of(:conference) }

    context 'when conference is Other' do
      subject { build(:team, conference: 'Other', other_conference: 'Custom Conference') }

      it { should validate_presence_of(:other_conference) }
    end

    it 'should validate max teams' do
      create_list(:team, Team::MAX_TEAMS - 1)
      team = build(:team)

      expect(team).to be_valid

      create(:team)
      team = build(:team)

      expect(team).to_not be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:draft_picks).dependent(:restrict_with_error) }
    it { should have_many(:user_leagues).through(:draft_picks) }
    it { should have_many(:leagues).through(:user_leagues) }
  end

  describe '#actual_conference' do
    it 'returns other_conference when conference is Other' do
      team = build(:team, conference: 'Other', other_conference: 'Custom Conference')
      expect(team.actual_conference).to eq('Custom Conference')
    end

    it 'returns conference when conference is not Other' do
      team = build(:team, conference: 'ACC')
      expect(team.actual_conference).to eq('ACC')
    end
  end
end
