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
      @bowling_game.reload
      expect(@bowling_game.finished?).to be true
  end

  context "when it has 10 frames" do
    before :each do
      (1..3).each do |num|
        FactoryGirl.create(:frame, bowling_game_id: @bowling_game.id, number: num, first_throw: 2, second_throw: 3, third_throw: nil)
      end
      (4..6).each do |num|
        FactoryGirl.create(:frame, bowling_game_id: @bowling_game.id, number: num, first_throw: 6, second_throw: 4, third_throw: nil)
      end
      (7..9).each do |num|
        FactoryGirl.create(:frame, bowling_game_id: @bowling_game.id, number: num, first_throw: 10, second_throw: nil, third_throw: nil)
      end
      FactoryGirl.create(:frame, bowling_game_id: @bowling_game.id, number: 10, first_throw: 10, second_throw: 10, third_throw: 10)
      @bowling_game.score_game
      @bowling_game.save
      @bowling_game.reload
    end
    it "must calculate frames correctly" do
      first_frame = @bowling_game.frames.where(number: 1).take
      frame_score = @bowling_game.score_frame first_frame     
      expect(frame_score).to eq(5)
      spare_frame = @bowling_game.frames.where(number: 4).take
      spare_score = @bowling_game.score_frame spare_frame
      expect(spare_score).to eq(16)
      (7..10).each do |num|
        strike_frame = @bowling_game.frames.where(number: num).take
        strike_score = @bowling_game.score_frame strike_frame
        expect(strike_score).to eq(30)
      end
    end

    it "must calculate score correctly" do
      expect(@bowling_game.score).to eq(187)
    end
  end

end
