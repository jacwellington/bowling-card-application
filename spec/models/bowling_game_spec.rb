require 'rails_helper'

RSpec.describe BowlingGame, :type => :model do
  before :each do
    @bowling_game = FactoryGirl.create(:bowling_game)
  end

  it "must have all ten frames to finish" do
    (1..9).each do |num|
      FactoryGirl.create(:frame, bowling_game_id: @bowling_game.id, number: num, first_throw: 2, second_throw: 3, third_throw: nil)
      expect(@bowling_game.finished?).to be false
    end
      FactoryGirl.create(:frame, bowling_game_id: @bowling_game.id, number: 10, first_throw: 2, second_throw: 3, third_throw: nil)
      expect(@bowling_game.finished?).to be true
  end
end
