# Represents an entire game of bowling.
class BowlingGame < ActiveRecord::Base
  belongs_to :user
  has_many :frames
   
  # Checks to see if the game has ten frames, numbered 1 through 10 attached to it.
  #
  # @returns True if there are ten frames.
  def finished?
    reload
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

end
