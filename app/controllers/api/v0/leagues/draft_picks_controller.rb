class Api::V0::Leagues::DraftPicksController < ApplicationController
  def index
    league = League.find(params[:league_id])
    draft_picks = league.draft_picks
    render json: DraftPickSerializer.new(draft_picks), status: 200
  end
end

