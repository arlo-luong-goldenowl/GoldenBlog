class UsersController < ApplicationController
  before_action :logged_in_user, only: [:profile, :edit, :change_password, :update_password]
  before_action :prepare_user, only: [:show]
  before_action :prepare_current_user, only: [:profile, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Signup Successful !"
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    # redirect to user profile page if user info is current logged user
    if(current_user && params[:id].to_i == current_user.id)
      return redirect_to profile_users_path(status: :new)
    end

    @posts = @user.posts.where(status: :approved).order(created_at: :desc).paginate(page: params[:page], per_page: 9)
  end

  def profile
    @status = params[:status]
    @posts = @user.posts.where(status: @status).order(created_at: :desc).paginate(page: params[:page], per_page: 9)
    render :profile
  end

  def edit
  end

  def update
    update_options = user_params
    update_options = update_options.merge({ image: params[:user][:image] }) if params[:user][:image]
    if(@user.update_attributes(update_options))
      flash[:success] = "Update profile Successful !"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def change_password
    render :change_password
  end

  def update_password
    password_params = user_params
    is_any_param_empty = password_params[:old_password].blank? || password_params[:new_password].blank? || password_params[:new_password_confirmation].blank?

    if(is_any_param_empty)
      flash.now[:danger] = "Can't let any inputs be blank"
      return render :change_password
    end

    is_match_old_password = current_user.authenticate(password_params[:old_password])

    if(!is_match_old_password)
      flash.now[:danger] = "Old password doesn't match your account's password"
      return render :change_password
    end

    if(password_params[:new_password] != password_params[:new_password_confirmation])
      flash.now[:danger] = "New password doesn't match your new password confirmation"
      return render :change_password
    end

    if(password_params[:new_password].length < 6)
      flash.now[:danger] = "Your new password too short, please try again"
      return render :change_password
    end

    current_user.password = password_params[:new_password]
    current_user.password_confirmation = password_params[:new_password_confirmation]
    current_user.save
    flash.now[:success] = "Change password success"
    render :change_password
  end

  def sendmail
    user = User.find_by(email: 'hienviluong125@gmail.com')
    PostMailer.post_deleted_email(user, 'xtitlex', 'yauthoryyy').deliver
    render plain: "#{user.email} - Email"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :old_password, :new_password, :new_password_confirmation)
  end

  def change_password_params
    params.require(:user).permit()
  end

  def prepare_user
    @user = User.find(params[:id])
  end

  def prepare_current_user
    @user = User.find(current_user.id)
  end
end
