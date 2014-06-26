# This class represents one frame of a bowling game. There are a total of ten frames in a game and each frame has up to 3 throws, but usually only 1 or 2.
class Frame < ActiveRecord::Base
  belongs_to :bowling_game

  # Frame must be between 1 and 10
  validates :number, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10}

  # First throw must be between 0 and 10
  validates :first_throw, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10}
  # Second throw must be between 0 and 10
  validates :second_throw, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10}, allow_nil: true
  # Third throw must be between 0 and 10
  validates :third_throw, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10}, allow_nil: true

  validates :second_throw, presence: true, if: :need_second_throw?
  validate :check_second_throw_not_needed
  validates :third_throw, presence: true, if: :need_third_throw?
  validate :check_third_throw_not_needed

  # This checks whether or not a second throw is required to not be null.
  #
  # @returns True if a second throw is required in this frame.
  def need_second_throw?
    first_throw != 10 || number == 10
  end

  # This checks whether or not a third throw is required to not be null.
  #
  # @returns True if a third throw is required in this frame.
  def need_third_throw?
    number == 10 && first_throw.to_i + second_throw.to_i >= 10
  end

  # Validates if the second throw is not needed.
  #
  # Fails validation if it's not the tenth frame and a strike.
  def check_second_throw_not_needed
    if number != 10 && strike?
      errors.add(:second_throw, "Second throw added but not needed.") if second_throw
    end
  end

  # Validates if the third throw is not needed.
  #
  # Fail validation if it's not the tenth frame,
  # or if it is the tenth frame and is not a strike or spare. 
  def check_third_throw_not_needed
    if number != 10 || !(strike? || spare?)
      errors.add(:third_throw, "Third throw added but not needed.") if third_throw
    end
  end

  # This checks if this frame is a strike.
  #
  # @returns True if it is a strike, else false.
  def strike?
    first_throw == 10
  end

  # This checks if this frame is a spare.
  #
  # @returns True if it is a spare, else false.
  def spare?
    !strike? && first_throw + second_throw == 10
  end
end
