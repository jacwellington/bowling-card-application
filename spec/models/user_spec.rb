require 'rails_helper'

RSpec.describe User, :type => :model do
  before :each do
    @user = FactoryGirl.build(:user)
  end
  
  it "is valid" do
    expect(@user.valid?).to be true
  end
end
