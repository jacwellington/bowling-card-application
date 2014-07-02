class BowlingGamesController < ApplicationController
  before_action :authenticate_user!

  # Show a single game
  def show
    @bowling_game = BowlingGame.with_comments_and_frames.with_user(current_user.id).find_by_id(params[:id])
    if !@bowling_game
      redirect_to(bowling_games_path)
    end
  end

  # List all games, frames, comments, and user average
  def index
    @bowling_games = BowlingGame.where(user_id: current_user.id)
    @average_score = current_user.average_score @bowling_games
  end

  # Fill out a form to create a new game with 10 frames
  def new
    @bowling_game = BowlingGame.new
    10.times {@bowling_game.frames.build }
    @bowling_game.comments.build
  end

  # Created a new game with the posted params
  def create
    @bowling_game = BowlingGame.new(bowling_game_params)
    @bowling_game.user_id = current_user.id
    if @bowling_game.finished?
      if @bowling_game.valid?
        @bowling_game.score_game
        @bowling_game.save
        redirect_to bowling_games_path
      else
        error = nil
        @bowling_game.frames.each do |frame|
          if frame.errors.count > 0
            error = "Frame number #{frame.number} - #{frame.errors.full_messages.first}"
          end
        end
        error = "Errors: " + @bowling_game.errors.full_messages.first if !error
        redirect_to new_bowling_game_path, error: error
      end
    else
      redirect_to new_bowling_game_path, error: "Youd did not complete the bowling game." 
    end
  end

  private 
  def bowling_game_params
    params.require(:bowling_game).permit(:user_id, frames_attributes: [:id, :first_throw, :second_throw, :third_throw, :number], comments_attributes: [:id, :body])
  end
end
