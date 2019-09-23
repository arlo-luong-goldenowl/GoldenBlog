class Admin::UsersController < Admin::BaseAdminController
  def index
    @users = User.order(created_at: :desc).paginate(page: params[:page], per_page: 8)
  end
end
