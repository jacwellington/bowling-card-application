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
      bowling_game.score_game
      bowling_game.save
      bowling_game.reload
    end
  end

  describe "GET show" do
    it "redirects to login when not signed in" do
      sign_in nil
      get :show, id: @bowling_game0.id
      expect(response).to redirect_to(new_user_session_path)
    end
    it "redirects to index when the user doesn't own the game" do
      user2 = FactoryGirl.create(:user)
      sign_in user2 
      get :show, id: @bowling_game0.id
      expect(response).to redirect_to(bowling_games_path)
    end
    it "renders the show page and assigns the correct bowling game to @bowling game" do
      sign_in @user
      get :show, id: @bowling_game0.id
      expect(assigns(:bowling_game).id).to eq(@bowling_game0.id) 
      expect(response).to render_template("show")
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
      



      post :create
      expect(response).to redirect_to(new_user_session_path)
    end
    it "successfully creates the bowling game" do
      sign_in @user
      params = {"utf8"=>"✓", "authenticity_token"=>"bVXZax1cc3DWwj+fhXeOY2e+4DK8y1s+QTg2chcQ8j4=", "bowling_game"=>{"frames_attributes"=>{"0"=>{"first_throw"=>"4", "second_throw"=>"4", "number"=>"1"}, "1"=>{"first_throw"=>"10", "second_throw"=>"", "number"=>"2"}, "2"=>{"first_throw"=>"4", "second_throw"=>"5", "number"=>"3"}, "3"=>{"first_throw"=>"5", "second_throw"=>"5", "number"=>"4"}, "4"=>{"first_throw"=>"10", "second_throw"=>"", "number"=>"5"}, "5"=>{"first_throw"=>"10", "second_throw"=>"", "number"=>"6"}, "6"=>{"first_throw"=>"9", "second_throw"=>"1", "number"=>"7"}, "7"=>{"first_throw"=>"4", "second_throw"=>"0", "number"=>"8"}, "8"=>{"first_throw"=>"5", "second_throw"=>"6", "number"=>"9"}, "9"=>{"first_throw"=>"10", "second_throw"=>"10", "third_throw"=>"10", "number"=>"10"}}, "comments_attributes"=>{"0"=>{"body"=>""}}}, "commit"=>"Submit"}
      post :create, params
      created_game = assigns(:bowling_game)
      expect(created_game).to be
      expect(created_game.finished?).to be true
      expect(BowlingGame.find(created_game.id)).to be
    end
  end
end
