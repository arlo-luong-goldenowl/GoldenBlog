class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please login before to do this action"
      redirect_to login_path
    end
  end
end
