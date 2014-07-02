# Represents an entire game of bowling.
class BowlingGame < ActiveRecord::Base
  belongs_to :user
  has_many :frames
  has_many :comments
  accepts_nested_attributes_for :frames
  accepts_nested_attributes_for :comments

  scope :with_comments_and_frames, includes(:comments, :frames)
  scope :with_user, ->(user_id) { where(user_id: user_id) }
   
  # Checks to see if the game has ten frames, numbered 1 through 10 attached to it.
  #
  # @returns True if there are ten frames.
  def finished?
    sorted_frames = frames.sort {|a,b| a.number <=> b.number}
    finished = true
    if sorted_frames.length == 10
      sorted_frames.zip(1..10).each do |frame_index_pair|
        if frame_index_pair[0].number != frame_index_pair[1]
          finished = false
        end
      end
    else
      finished = false
    end
    return finished
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
      frame_score = frame.first_throw + next_two_throws(frame)
    elsif frame.spare?
      frame_score = frame.first_throw + frame.second_throw + next_throw(frame)
    else
      frame_score = frame.first_throw + frame.second_throw
    end
    return frame_score
  end

  # Get the next frame from the frame a spare happened on
  #
  # @params frame [Frame] The current frame in which the spare occured.
  def next_throw frame
    if frame.number != 10
      #next_frame = frames.where(number: frame.number + 1).take
      next_frame = frames.select{ |related_frame| related_frame.number == frame.number + 1}.first
      return next_frame.first_throw
    else
      return frame.third_throw
    end
  end

  # Get the next two throws from the frame a strike happened on.
  #
  # @params frame [Frame] The current frame in which the strike occured.
  def next_two_throws frame
    if frame.number != 10
      next_frame = frames.select{|related_frame| related_frame.number ==  frame.number + 1}.first
      first_throw = next_frame.first_throw
      if next_frame.strike?
        if next_frame.number != 10
          secondary_frame = frames.select{|related_frame| related_frame.number ==  next_frame.number + 1}.first
          second_throw = secondary_frame.first_throw
        else
          second_throw = next_frame.second_throw
        end
      else
        second_throw = next_frame.second_throw
      end
    else
      first_throw = frame.second_throw
      second_throw = frame.third_throw
    end
    return first_throw + second_throw
  end

end
