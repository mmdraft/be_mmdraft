class Api::V0::TeamsController < ApplicationController
  before_action :set_team, only: %i[show]

  def index
    teams = Team.all
    render json: TeamSerializer.new(teams), status: 200
  end

  def show
    render json: TeamSerializer.new(team), status: 200
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end
end
