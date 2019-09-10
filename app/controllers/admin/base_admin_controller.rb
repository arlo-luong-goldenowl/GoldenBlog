class Admin::BaseAdminController < ActionController::Base
  layout "admin_layout"
  protect_from_forgery with: :exception
  before_action :logged_in_user
  before_action :is_admin

  include SessionsHelper

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
      redirect_to profile_users_path(status: :new)
    end
  end
end
