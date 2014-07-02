require 'rails_helper'

RSpec.describe Frame, :type => :model do
  before :each do
    @frame = FactoryGirl.build(:frame)
  end

  it "by default is valid" do
    expect(@frame.valid?).to be true
  end

  it "only can have a number of 1 through 10" do
    @frame.number = 0
    expect(@frame.valid?).to be false
    @frame.number = 11
    expect(@frame.valid?).to be false
    (1..10).each do |num|
      @frame.number = num
      expect(@frame.valid?).to be true
    end
  end

  it "is a strike when the first throw is 10" do
    @frame.first_throw = 10
    expect(@frame.strike?).to be true
  end

  it "is a spare when the first throw plus the second throw equals 10, but is not a strike" do
    @frame.first_throw = 5
    @frame.second_throw = 5
    expect(@frame.spare?).to be true
    @frame.first_throw = 10
    @frame.second_throw = 0
    expect(@frame.spare?).to be false
  end

  context "with all three throws inputed" do
    it "is only valid on the tenth frame" do
      @frame.first_throw = 10
      @frame.second_throw = nil
      @frame.third_throw = 2
      @frame.number = 4
      expect(@frame.valid?).to be false
      @frame.second_throw = 2
      @frame.number = 10
      expect(@frame.valid?).to be true
    end
  end

  context "each throw" do
    it "can't be a negative number" do
      @frame.first_throw = -1
      expect(@frame.valid?).to be false
      @frame = FactoryGirl.build(:frame)
      @frame.second_throw = -1
      expect(@frame.valid?).to be false
      @frame = FactoryGirl.build(:frame)
      @frame.third_throw = -1
      expect(@frame.valid?).to be false
    end

    it "can't be greater than 10" do
      @frame.first_throw = 11
      expect(@frame.valid?).to be false
      @frame = FactoryGirl.build(:frame)
      @frame.second_throw = 11
      expect(@frame.valid?).to be false
      @frame = FactoryGirl.build(:frame)
      @frame.third_throw = 11
      expect(@frame.valid?).to be false
    end

    it "combined can't be greater than ten if the first frame wasn't a strike" do
      @frame.first_throw = 9
      @frame.second_throw = 2
      @frame.number = 9
      expect(@frame.valid?).to be false
      @frame.first_throw = 10
      @frame.second_throw = 2
      @frame.third_throw = 1
      @frame.number = 10
      expect(@frame.valid?).to be true
    end
  end
  context "first throw" do
    it "can't be nil" do
      @frame.first_throw = nil
      expect(@frame.valid?).to be false
    end
  end
  context "second throw" do
    context "on any non-last frame" do
      it "can only be nil if the first_throw was 10" do
        (1..9).each do |num|
          @frame.number = num
          @frame.first_throw = 9
          @frame.second_throw = nil
          expect(@frame.valid?).to be false
          @frame.first_throw = 10
          @frame.second_throw = 9
          expect(@frame.valid?).to be false
        end
      end
    end
    context "on the last frame" do
      it "can never be nil" do
        @frame.number = 10
        @frame.first_throw = 10
        @frame.second_throw = nil
        @frame.third_throw = 1
        expect(@frame.valid?).to be false
        @frame.second_throw = 0
        @frame.third_throw = 1
        expect(@frame.valid?).to be true
      end
    end
  end
  context "third throw" do
    context "on any non-last frame" do
      it "should always be nil" do
        (1..9).each do |num|
          @frame.third_throw = 1
          expect(@frame.valid?).to be false
        end
      end
    end
    context "on the last frame" do
      it "must exist only on strike or spare" do
        @frame.number = 10
        @frame.first_throw = 10
        @frame.third_throw = nil
        expect(@frame.valid?).to be false
        @frame.third_throw = 1
        expect(@frame.valid?).to be true
        @frame.first_throw = 5
        @frame.second_throw = 5
        @frame.third_throw = nil
        expect(@frame.valid?).to be false
        @frame.third_throw = 1
        expect(@frame.valid?).to be true
      end
    end
  end 
end
