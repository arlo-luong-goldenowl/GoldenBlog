class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :get_latest_posts

  include SessionsHelper
  include LikesHelper

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please login before to do this action"
      redirect_to login_path
    end
  end

  def get_latest_posts
    @latest_posts = Post.all
      .order(created_at: :desc)
      .limit(5)
  end
end
