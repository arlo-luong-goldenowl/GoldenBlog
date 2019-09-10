class Admin::UsersController < ApplicationController
  before_action :logged_in_user
  before_action :is_admin

  def index
    @users = User.paginate(page: params[:page], per_page: 8).order(created_at: :desc)
  end
end
