# Basic user class to do authentication and keep track of games.
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bowling_games

  # Calculate the average score over all the games the user has played
  #
  # @param [BowlingGame List] The games to calculate the average score over.
  # @returns The average score over all bowling games.
  def average_score all_bowling_games = bowling_games
    total_score = all_bowling_games.reduce(0) { |sum, bowling_game| sum + bowling_game.score }
    total_score / all_bowling_games.length.to_f
  end

end
