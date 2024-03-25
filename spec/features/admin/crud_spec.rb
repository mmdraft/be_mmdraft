require 'rails_helper'

RSpec.describe 'Admin CRUD' do
  before :each do
    @admin = create(:user, admin: true)
    @user = create(:user)
    @league = create(:league, manager_id: @user.id)
    @team = create(:team)
    @user_league = create(:user_league, user_id: @user.id, league_id: @league.id)
  end

  describe 'Admin CRUD for Teams' do
    it 'can see all teams' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_teams_path

      expect(page).to have_content(@team.name)
      expect(page).to have_content(@team.seed)
      expect(page).to have_content(@team.region)
      expect(page).to have_content(@team.conference)
    end

    it 'can see a single team' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_team_path(@team)

      expect(page).to have_content(@team.name)
      expect(page).to have_content(@team.seed)
      expect(page).to have_content(@team.region)
      expect(page).to have_content(@team.conference)
    end

    it 'can create a new team' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit new_admin_team_path

      fill_in 'Name', with: 'Test Team'
      fill_in 'Seed', with: 1
      fill_in 'Region', with: 'West'
      fill_in 'Conference', with: 'Pac-12'
      click_button 'Create Team'

      expect(page).to have_content('Test Team')
      expect(page).to have_content(1)
      expect(page).to have_content('West')
      expect(page).to have_content('Pac-12')
    end

    it 'can update a team' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit edit_admin_team_path(@team)

      fill_in 'Name', with: 'Updated Team'
      fill_in 'Seed', with: 2
      fill_in 'Region', with: 'East'
      fill_in 'Conference', with: 'Big East'
      click_button 'Update Team'

      expect(page).to have_content('Updated Team')
    end

    it 'can delete a team' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_teams_path

      expect(page).to have_content(@team.name)

      click_link 'Delete'

      expect(page).to_not have_content(@team.name)
    end

    it 'can delete all teams' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_teams_path

      expect(page).to have_content(@team.name)

      click_link 'Delete All Teams'

      expect(page).to_not have_content(@team.name)
    end
  end
end
