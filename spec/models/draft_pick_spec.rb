require 'rails_helper'

RSpec.describe DraftPick, type: :model do
  describe 'relationships' do
    it { should belong_to(:user_league) }
    it { should belong_to(:team) }
  end

  describe 'validations' do
  end
end
