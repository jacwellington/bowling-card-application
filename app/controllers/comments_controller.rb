class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_user_owns_bowling_game

  # Form to create a new comment for a specific game
  def new
    @comment = Comment.new
    @bowling_game_id = params[:id]
  end

  # Post to create a new comment for a specific bowling game
  def create
    @comment = Comment.new(comment_params)
    @comment.bowling_game_id = params[:id]
    @comment.save
    redirect_to (bowling_games_path)
  end

  private
  def comment_params
    params.require(:comment).permit(:body)
  end

  # Redirects if the bowling game doesn't exist or the user doesn't own it
  def check_if_user_owns_bowling_game
    bowling_game = BowlingGame.where(user_id: current_user.id, id: params[:id]).take
    if !bowling_game
      redirect_to bowling_games_path
    else
      @bowling_game_id = params[:id]
    end
  end
end
