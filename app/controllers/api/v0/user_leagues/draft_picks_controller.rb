class Api::V0::UserLeagues::DraftPicksController < ApplicationController
  def index
    user_league = UserLeague.find(params[:user_league_id])
    draft_picks = user_league.draft_picks
    render json: DraftPickSerializer.new(draft_picks), status: 200
  end

  def create
    user_league = UserLeague.find(params[:user_league_id])
    draft_pick = user_league.draft_picks.build(draft_pick_params)

    if draft_pick.save
      render json: DraftPickSerializer.new(draft_pick), status: :created
    else
      render json: { errors: draft_pick.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def draft_pick_params
    params.require(:draft_pick).permit(:round_number, :team_id, :draft_order)
  end
end
