# Represents an entire game of bowling.
class BowlingGame < ActiveRecord::Base
  belongs_to :user
  has_many :frames
  has_many :comments
  accepts_nested_attributes_for :frames
  accepts_nested_attributes_for :comments

  scope :with_comments_and_frames, includes(:comments, :frames)
  scope :with_user, ->(user_id) { where(user_id: user_id) }
   
  # Checks if the game has ten frames.
  #
  # @returns True if there are ten frames, numbered 1 through 10.
  def finished?
    sorted_frames = frames.sort {|a,b| a.number <=> b.number}
    sorted_frames.length == 10 && check_frames_one_to_ten(sorted_frames)
  end

  # Score the game by adding up the socres of each individual frame.
  def score_game
    self.score = frames.reduce(0) { |sum, frame| sum + score_frame(frame) } 
  end

  # Score an individual frame.
  #
  # @params frame [Frame] The frame to score.
  def score_frame frame
    if frame.strike?
      frame.first_throw + next_two_throws_after_strike(frame)
    elsif frame.spare?
      frame.first_throw + frame.second_throw + next_throw_after_spare(frame)
    else
      frame.first_throw + frame.second_throw
    end
  end

  private

  # Get the next throw from the frame a spare happened on
  #
  # @params frame [Frame] The current frame in which the spare occured.
  # @returns The value of the next throw after a spare.
  def next_throw_after_spare frame
    if frame.number != 10
      next_frame(frame).first_throw
    else
      frame.third_throw
    end
  end

  # Get the sum of the next two throws from the frame a strike happened on.
  #
  # @params frame [Frame] The current frame in which the strike occured.
  # @returns The sum of the next two throws after a strike.
  def next_two_throws_after_strike frame
    if frame.number != 10
      next_frame = next_frame(frame)
      first_throw = next_frame.first_throw
      second_throw = second_throw_after_strike(next_frame)
    else
      first_throw = frame.second_throw
      second_throw = frame.third_throw
    end
    first_throw + second_throw
  end
  
  # Gets the second throw to add to a strike.
  #
  # @params next_frame [Frame] The next frame after the strike occured.
  # @returns The value of the second throw after a strike.
  def second_throw_after_strike(next_frame)
    if next_frame.strike? && next_frame.number != 10
        secondary_frame = next_frame(next_frame)
        second_throw = secondary_frame.first_throw
    else
      second_throw = next_frame.second_throw
    end
  end

  # Gets the next frame.
  #
  # @params current_frame [Frame] Current frame that is not the last frame.
  # @returns The next frame after the current frame.
  def next_frame(current_frame)
    frames.select{|related_frame| related_frame.number ==  current_frame.number + 1}.first
  end

  # Checks to see if all frames are numbered 1 through 10.
  #
  # @params sorted_frames [Array] A list of all the frames sorted 1 through ten.
  # @returns True if the frames are numbered 1 through 10.
  def check_frames_one_to_ten(sorted_frames)
    has_ten_frames = true
    sorted_frames.zip(1..10).each do |frame_index_pair|
      if frame_index_pair[0].number != frame_index_pair[1]
        has_ten_frames = false
      end
    end
    return has_ten_frames 
  end

end
