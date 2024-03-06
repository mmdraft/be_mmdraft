require 'rails_helper'

RSpec.describe 'League Requests' do
  describe 'Create a new league' do
    describe 'Happy Path' do
      it 'can create a new league and associated user league' do
        @user = create(:user)
        @league_params = {
          name: 'Test League',
          manager_id: @user.id,
          draft_status: 'in_progress',
          draft_date_time: '2021-08-01T12:00:00.000Z'
        }
        @headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v0/leagues', headers: @headers, params: JSON.generate(league: @league_params)

        expect(response).to be_successful
        expect(response).to have_http_status(201)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to be_a(Hash)
        expect(data[:data]).to be_a(Hash)

        expect(data[:data]).to have_key(:type)
        expect(data[:data][:type]).to eq('league')

        expect(data[:data]).to have_key(:id)
        expect(data[:data][:id]).to be_an(String)

        expect(data[:data]).to have_key(:attributes)
        expect(data[:data][:attributes]).to be_a(Hash)

        expect(data[:data][:attributes]).to have_key(:name)
        expect(data[:data][:attributes][:name]).to eq(@league_params[:name])

        expect(data[:data][:attributes]).to have_key(:manager_id)
        expect(data[:data][:attributes][:manager_id]).to eq(@league_params[:manager_id])

        expect(data[:data][:attributes]).to have_key(:draft_status)
        expect(data[:data][:attributes][:draft_status]).to eq(@league_params[:draft_status])

        expect(data[:data][:attributes]).to have_key(:draft_date_time)
        expect(data[:data][:attributes][:draft_date_time]).to eq(@league_params[:draft_date_time])

        expect(UserLeague.find_by(user_id: @user.id, league_id: data[:data][:id])).to be_a(UserLeague)
      end
    end


    describe 'Sad Path' do
      it 'returns an error if required fields are missing' do
        @user = create(:user)
        @league_params = {
          name: 'Test League',
          manager_id: @user.id
        }
        @headers = { 'CONTENT_TYPE' => 'application/json' }

        post '/api/v0/leagues', headers: @headers, params: JSON.generate(league: @league_params)

        expect(response).to_not be_successful
        expect(response).to have_http_status(422)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to be_a(Hash)
        expect(data[:errors][:detail]).to eq('Draft status can\'t be blank, Draft date time can\'t be blank')
      end
    end
  end

  describe 'Send all leagues' do
    before(:each) do
      @user1 = create(:user)
      @user2 = create(:user)

      @league1 = create(:league, manager_id: @user1.id)
      @league2 = create(:league, manager_id: @user2.id)
      @league3 = create(:league, manager_id: @user2.id)

      @user_league1 = create(:user_league, user_id: @user1.id, league_id: @league1.id)
      @user_league2 = create(:user_league, user_id: @user1.id, league_id: @league2.id)
      @user_league3 = create(:user_league, user_id: @user2.id, league_id: @league3.id)
    end

    describe 'Happy Path' do
      it 'can send all leagues for a user' do
        get "/api/v0/users/#{@user1[:id]}/leagues"

        expect(response).to be_successful
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to be_a(Hash)
        expect(json[:data]).to be_an(Array)
        expect(json[:data].count).to eq(2)

        json[:data].each do |league|
          expect(league).to have_key(:id)
          expect(league[:id]).to be_an(String)

          expect(league).to have_key(:type)
          expect(league[:type]).to eq('league')

          expect(league).to have_key(:attributes)
          expect(league[:attributes]).to be_a(Hash)

          expect(league[:attributes]).to have_key(:name)
          expect(league[:attributes][:name]).to be_a(String)

          expect(league[:attributes]).to have_key(:manager_id)
          expect(league[:attributes][:manager_id]).to be_an(Integer)

          expect(league[:attributes]).to have_key(:draft_status)
          expect(league[:attributes][:draft_status]).to be_a(String)

          expect(league[:attributes]).to have_key(:draft_date_time)
          expect(league[:attributes][:draft_date_time]).to be_a(String)
        end
      end
    end

    describe 'Sad Path' do
      it 'returns an error if user does not exist' do
        get "/api/v0/users/0/leagues"

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to be_a(Hash)
        expect(data[:errors][:detail]).to eq("Couldn't find User with 'id'=0")
      end
    end
  end

  describe 'Send a single league' do
    describe 'Happy Path' do
      it 'can send a single league' do
        @user = create(:user)
        @league = create(:league, manager_id: @user.id)

        get "/api/v0/leagues/#{@league[:id]}"

        expect(response).to be_successful
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to be_a(Hash)
        expect(json[:data]).to be_a(Hash)

        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to be_an(String)

        expect(json[:data]).to have_key(:type)
        expect(json[:data][:type]).to eq('league')

        expect(json[:data]).to have_key(:attributes)
        expect(json[:data][:attributes]).to be_a(Hash)

        expect(json[:data][:attributes]).to have_key(:name)
        expect(json[:data][:attributes][:name]).to be_a(String)

        expect(json[:data][:attributes]).to have_key(:manager_id)
        expect(json[:data][:attributes][:manager_id]).to be_an(Integer)

        expect(json[:data][:attributes]).to have_key(:draft_status)
        expect(json[:data][:attributes][:draft_status]).to be_a(String)

        expect(json[:data][:attributes]).to have_key(:draft_date_time)
        expect(json[:data][:attributes][:draft_date_time]).to be_a(String)
      end
    end

    describe 'Sad Path' do
      it 'returns an error if league does not exist' do
        get "/api/v0/leagues/0"

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to be_a(Hash)
        expect(data[:errors][:detail]).to eq("Couldn't find League with 'id'=0")
      end
    end
  end

  describe 'Update a league' do
    describe 'Happy Path' do
      it 'can update a league' do
        @user = create(:user)
        @league = create(:league, manager_id: @user.id)
        @update_params = { name: 'Updated League Name' }

        @headers = { 'CONTENT_TYPE' => 'application/json' }

        patch "/api/v0/leagues/#{@league[:id]}", headers: @headers, params: JSON.generate(league: @update_params)

        expect(response).to be_successful
        expect(response).to have_http_status(200)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to be_a(Hash)
        expect(json[:data]).to be_a(Hash)

        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to be_an(String)

        expect(json[:data]).to have_key(:type)
        expect(json[:data][:type]).to eq('league')

        expect(json[:data]).to have_key(:attributes)
        expect(json[:data][:attributes]).to be_a(Hash)

        expect(json[:data][:attributes]).to have_key(:name)
        expect(json[:data][:attributes][:name]).to eq(@update_params[:name])
      end
    end

    describe 'Sad Path' do
      it 'returns an error if league does not exist' do
        @update_params = { name: 'Updated League Name' }

        @headers = { 'CONTENT_TYPE' => 'application/json' }

        patch "/api/v0/leagues/0", headers: @headers, params: JSON.generate(league: @update_params)

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to be_a(Hash)
        expect(data[:errors][:detail]).to eq("Couldn't find League with 'id'=0")
      end
    end
  end

  describe 'Delete a league' do
    describe 'Happy Path' do
      it 'can delete a league' do
        @user = create(:user)
        @league = create(:league, manager_id: @user.id)
        @league2 = create(:league, manager_id: @user.id)

        expect(League.all.count).to eq(2)

        delete "/api/v0/leagues/#{@league[:id]}"

        expect(response).to be_successful
        expect(response).to have_http_status(204)
        expect(League.all.count).to eq(1)
      end
    end

    describe 'Sad Path' do
      it 'returns an error if league does not exist' do
        delete "/api/v0/leagues/0"

        expect(response).to_not be_successful
        expect(response).to have_http_status(404)

        data = JSON.parse(response.body, symbolize_names: true)

        expect(data).to be_a(Hash)
        expect(data[:errors][:detail]).to eq("League not found")
      end
    end
  end
end
