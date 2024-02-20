require 'rails_helper'

RSpec.describe League, type: :model do
  describe 'relationships' do
    it { should have_many(:user_leagues) }
    it { should have_many(:users).through(:user_leagues) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end
end
