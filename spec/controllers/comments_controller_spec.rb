require 'rails_helper'

RSpec.describe CommentsController, :type => :controller do
  before :each do
    @user = FactoryGirl.create(:user)
    @bowling_game = FactoryGirl.create(:bowling_game, user_id: @user.id)
    @comment = FactoryGirl.build(:comment)
  end

  describe "GET new" do
    it "redirects to login when not signed in" do
      sign_in nil
      #get "bowling_games/#{@bowling_game.id}/create-comment"
      get :new, id: @bowling_game.id
      expect(response).to redirect_to(new_user_session_path)
    end
    it "only allows creating forms for games the user owns" do
      user2 = FactoryGirl.create(:user)
      sign_in user2
      get :new, id: @bowling_game.id
      expect(response).to redirect_to(bowling_games_path)
    end
    it "only allows creating forms for games that exist" do
      sign_in @user
      get :new, id: 5000
      expect(response).to redirect_to(bowling_games_path)
    end
    it "renders the new template" do
      sign_in @user
      get :new, id: @bowling_game.id
      expect(response).to render_template("comments/new")
    end
  end
  describe "POST create" do
    it "only allows to create comments for games the user owns" do
      user2 = FactoryGirl.create(:user)
      sign_in user2
      post :create, id: @bowling_game.id, comment: {body: "test2"}
      expect(Comment.where(body: "test2", bowling_game_id: @bowling_game.id).count).to eq(0)
      expect(response).to redirect_to(bowling_games_path)
    end
    it "it creates a new comment" do
      sign_in @user
      post :create, id: @bowling_game.id, comment: {body: "test2"}
      expect(Comment.where(body: "test2", bowling_game_id: @bowling_game.id).count).to eq(1)
      expect(response).to redirect_to(bowling_games_path)
    end
  end
end
