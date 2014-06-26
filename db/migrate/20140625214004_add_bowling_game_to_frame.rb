class AddBowlingGameToFrame < ActiveRecord::Migration
  def change
    add_reference :frames, :bowling_game, index: true
  end
end
