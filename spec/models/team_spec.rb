require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'relationships' do
    it { should have_many(:draft_picks) }
    it { should have_many(:user_leagues).through(:draft_picks) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:seed) }
    it { should validate_presence_of(:region) }
    it { should validate_presence_of(:conference) }
  end
end
