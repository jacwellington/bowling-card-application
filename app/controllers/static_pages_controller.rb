class StaticPagesController < ActionController::Base
  before_action :authenticate_user!
  def hidden
  end
end
