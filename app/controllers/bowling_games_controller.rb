class BowlingGamesController < ApplicationController
  before_action :authenticate_user!
  def index
    @bowling_games = BowlingGame.where(user_id: current_user.id)
  end

  def new
    @bowling_game = BowlingGame.new
    10.times {@bowling_game.frames.build }
  end

  def create
    @bowling_game = BowlingGame.new(bowling_game_params)
    @bowling_game.user_id = current_user.id
    if @bowling_game.finished?
      @bowling_game.score
      @bowling_game.save
    end
    redirect_to bowling_games_path
  end

  private 
  def bowling_game_params
    params.require(:bowling_game).permit(:user_id, frames_attributes: [:id, :first_throw, :second_throw, :third_throw, :number])
  end
end
