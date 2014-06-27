require 'rails_helper'

RSpec.describe BowlingGamesController, :type => :controller do
  before :each do
    @user = FactoryGirl.create(:user)
    @bowling_game0 = FactoryGirl.create(:bowling_game, user_id: @user.id)
    @bowling_game1 = FactoryGirl.create(:bowling_game, user_id: @user.id)
    @bowling_game2 = FactoryGirl.create(:bowling_game, user_id: @user.id)
    bowling_games = []
    bowling_games[0] = @bowling_game0
    bowling_games[1] = @bowling_game1
    bowling_games[2] = @bowling_game2
    3.times do |time|
      (1..3).each do |num|
        FactoryGirl.create(:frame, bowling_game_id: bowling_games[time].id, number: num, first_throw: 2, second_throw: 3, third_throw: nil)
      end
      (4..6).each do |num|
        FactoryGirl.create(:frame, bowling_game_id: bowling_games[time].id, number: num, first_throw: 6, second_throw: 4, third_throw: nil)
      end
      (7..9).each do |num|
        FactoryGirl.create(:frame, bowling_game_id: bowling_games[time].id, number: num, first_throw: 10, second_throw: nil, third_throw: nil)
      end
      FactoryGirl.create(:frame, bowling_game_id: bowling_games[time].id, number: 10, first_throw: 10, second_throw: 10, third_throw: 10)
    end
    bowling_games.each do |bowling_game|
      bowling_game.reload
    end
  end
  describe "GET index" do
    it "redirects to login when not signed in" do
      sign_in nil
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
    it "gets all the bowling games for a user" do
      sign_in @user
      get :index
      expect(assigns(:bowling_games).length).to eq(3) 
    end
    it "renders the index template" do
      sign_in @user
      get :index
      expect(response).to render_template("index")
    end
  end
  describe "GET new" do
    it "redirects to login when not signed in" do
      sign_in nil
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
    it "creates a bowling game with 10 frames built" do
      sign_in @user
      get :new
      expect(assigns(:bowling_game)).to be
      expect(assigns(:bowling_game).frames.length).to eq(10)
    end
    it "renders the new template" do
      sign_in @user
      get :new
      expect(response).to render_template("new")
    end
  end
  describe "POST create" do
    it "redirects to login when not signed in" do
      sign_in nil
      get :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
