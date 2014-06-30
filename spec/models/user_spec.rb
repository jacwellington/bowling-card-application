require 'rails_helper'

RSpec.describe User, :type => :model do
  before :each do
    @user = FactoryGirl.create(:user)
    2.times do |index|
      bowling_game = FactoryGirl.create(:bowling_game, user_id: @user.id)
      (1..3).each do |num|
        FactoryGirl.create(:frame, bowling_game_id: bowling_game.id, number: num, first_throw: 2, second_throw: 3, third_throw: nil)
      end
      (4..6).each do |num|
        FactoryGirl.create(:frame, bowling_game_id: bowling_game.id, number: num, first_throw: 6, second_throw: 4, third_throw: nil)
      end
      (7..9).each do |num|
        FactoryGirl.create(:frame, bowling_game_id: bowling_game.id, number: num, first_throw: 10, second_throw: nil, third_throw: nil)
      end
      FactoryGirl.create(:frame, bowling_game_id: bowling_game.id, number: 10, first_throw: 10, second_throw: index, third_throw: 10)
      bowling_game.score_game
      bowling_game.save
      bowling_game.reload
    end
  end

  it "is valid" do
    expect(@user.valid?).to be true
  end

  it "calculates an average bowling game score" do
    @user.reload
    expect(@user.average_score).to eq(168.to_f)
  end
end
