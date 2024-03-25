class Admin::TeamsController < Admin::BaseController
  before_action :set_team, only: %i[show edit update destroy]

  def index
    @teams = Team.all
  end

  def show
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.create!(team_params)
    redirect_to admin_teams_path
  end

  def edit
  end

  def update
    @team.update(team_params)
    redirect_to admin_teams_path
  end

  def destroy
    @team.destroy
    redirect_to admin_teams_path
  end

  def destroy_all
    Team.destroy_all
    redirect_to admin_teams_path
  end


  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :seed, :actual_conference, :region)
  end
end
