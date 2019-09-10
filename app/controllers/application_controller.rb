class ApplicationController < ActionController::Base
  layout :conditional_layout
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

  def is_admin
    unless is_admin?
      flash[:danger] = "Permission denied to access this url"
      redirect_to profile_users_path
    end
  end

  def get_latest_posts
    @latest_posts = Post
      .where(status: :approved)
      .order(created_at: :desc)
      .limit(5)
  end

  def conditional_layout
    request.original_url.include?("/admin/") ? "admin_layout" : "application"
  end
end
