class Api::V0::LeaguesController < ApplicationController
  def show
    league = League.find(params[:id])
    render json: LeagueSerializer.new(league), status: 200
  end

  def create
    league = League.create!(league_params)
    UserLeague.create!(user_id: league.manager_id, league_id: league.id)
    render json: LeagueSerializer.new(league), status: 201
  end

  def update
    league = League.find(params[:id])

    if league.update(league_params)
      render json: LeagueSerializer.new(league), status: 200
    else
      render json: { errors: league.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    league = League.find_by(id: params[:id])

    if league
      league.destroy
      head :no_content
    else
      render json: { errors: { detail: 'League not found' } }, status: :not_found
    end
  end


  private

  def league_params
    params.require(:league).permit(:name, :manager_id, :draft_status, :draft_date_time)
  end
end
