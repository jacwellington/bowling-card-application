require 'rails_helper'

RSpec.describe Comment, :type => :model do
  before :each do
    @comment = FactoryGirl.build(:comment)
  end
  it "should be valid" do
    expect(@comment.valid?).to be true
  end
end
