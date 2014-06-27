require 'rails_helper'

RSpec.describe Comment, :type => :model do
  before :each do
    @comment = FactoryGirl.build(:comment)
  end
  it "should require a bowling_game" do
    @comment.bowling_game_id = nil
    expect(@comment.valid?).to be false
  end
end
