require 'rails_helper'

RSpec.describe 'User League Requests' do
  describe 'User League Creation' do
    before :each do
      @user = create(:user)
      @league = create(:league, manager_id: @user.id)
      @user_league_params = { user_id: @user.id, league_id: @league.id }
      @bad_user_league_params = { user_id: @user.id }
      @headers = { 'CONTENT_TYPE' => 'application/json' }
    end

    describe 'Happy Path' do
      it 'can create a new user league' do
        post '/api/v0/user_leagues', headers: @headers, params: JSON.generate(user_league: @user_league_params)

        expect(response).to be_successful
        expect(response).to have_http_status(201)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to be_a(Hash)
        expect(data[:data]).to be_a(Hash)

        expect(data[:data]).to have_key(:type)
        expect(data[:data][:type]).to eq('user_league')

        expect(data[:data]).to have_key(:id)
        expect(data[:data][:id]).to be_an(String)

        expect(data[:data]).to have_key(:attributes)
        expect(data[:data][:attributes]).to be_a(Hash)

        expect(data[:data][:attributes]).to have_key(:user_id)
        expect(data[:data][:attributes][:user_id]).to eq(@user_league_params[:user_id])

        expect(data[:data][:attributes]).to have_key(:league_id)
        expect(data[:data][:attributes][:league_id]).to eq(@user_league_params[:league_id])
      end
    end

    describe 'Sad Path' do
      it 'returns an error if required fields are missing' do
        post '/api/v0/user_leagues', headers: @headers, params: JSON.generate(user_league: @bad_user_league_params)

        expect(response).to_not be_successful
        expect(response).to have_http_status(422)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to be_a(Hash)
        expect(json[:errors][:detail]).to eq('League must exist')
      end
    end
  end

  describe 'User League Deletion' do
    before :each do
      @user = create(:user)
      @league = create(:league, manager_id: @user.id)
      @user_league = create(:user_league, user_id: @user.id, league_id: @league.id)
    end

    describe 'Happy Path' do
      it 'can delete a user league' do
        delete "/api/v0/user_leagues/#{@user_league[:id]}"

        expect(response).to be_successful
        expect(response).to have_http_status(204)
      end
    end

    describe 'Sad Path' do
      it 'returns an error if the user league does not exist' do
        delete "/api/v0/user_leagues/0"

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'Send all UserLeagues for a league' do
    before :each do
      @user = create(:user)
      @user2 = create(:user)
      @league = create(:league, manager_id: @user.id)
      @user_league = create(:user_league, user_id: @user.id, league_id: @league.id)
      @user_league2 = create(:user_league, user_id: @user2.id, league_id: @league.id)
    end

    describe 'Happy Path' do
      it 'can send all user leagues for a league' do
        get "/api/v0/leagues/#{@league[:id]}/user_leagues"

        expect(response).to be_successful
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to be_a(Hash)
        expect(json[:data]).to be_an(Array)
        expect(json[:data].count).to eq(2)

        json[:data].each do |user_league|
          expect(user_league).to have_key(:id)
          expect(user_league[:id]).to be_an(String)

          expect(user_league).to have_key(:type)
          expect(user_league[:type]).to eq('user_league')

          expect(user_league).to have_key(:attributes)
          expect(user_league[:attributes]).to be_a(Hash)

          expect(user_league[:attributes]).to have_key(:user_id)
          expect(user_league[:attributes][:user_id]).to be_an(Integer)

          expect(user_league[:attributes]).to have_key(:league_id)
          expect(user_league[:attributes][:league_id]).to be_an(Integer)
        end
      end
    end

    describe 'Sad Path' do
      it 'returns an error if league does not exist' do
        get "/api/v0/leagues/0/user_leagues"

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to be_a(Hash)
        expect(json[:errors][:detail]).to eq("Couldn't find League with 'id'=0")
      end
    end
  end

  describe 'Send One UserLeague' do
    before :each do
      @user = create(:user)
      @user2 = create(:user)
      @league = create(:league, manager_id: @user.id)
      @user_league = create(:user_league, user_id: @user.id, league_id: @league.id)
      @user_league2 = create(:user_league, user_id: @user2.id, league_id: @league.id)
    end

    describe 'Happy Path' do
      it 'can send a single user league' do
        get "/api/v0/user_leagues/#{@user_league[:id]}"

        expect(response).to be_successful
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to be_a(Hash)
        expect(json[:data]).to be_a(Hash)

        expect(json[:data]).to have_key(:type)
        expect(json[:data][:type]).to eq('user_league')

        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to be_an(String)

        expect(json[:data]).to have_key(:attributes)
        expect(json[:data][:attributes]).to be_a(Hash)

        expect(json[:data][:attributes]).to have_key(:user_id)
        expect(json[:data][:attributes][:user_id]).to eq(@user_league[:user_id])

        expect(json[:data][:attributes]).to have_key(:league_id)
        expect(json[:data][:attributes][:league_id]).to eq(@user_league[:league_id])
      end
    end

    describe 'Sad Path' do
      it 'returns an error if user league does not exist' do
        get "/api/v0/user_leagues/0"

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to be_a(Hash)
        expect(json[:errors][:detail]).to eq("Couldn't find UserLeague with 'id'=0")
      end
    end
  end
end
