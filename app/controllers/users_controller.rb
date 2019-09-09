class UsersController < ApplicationController
  before_action :logged_in_user, only: [:profile, :edit, :change_password, :update_password]

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

  def profile
    @user = User.find(current_user.id)
    render :profile
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(current_user.id)
    update_options = user_update_params
    if(params[:user][:image])
      update_options = update_options.merge({image: params[:user][:image]})
    end
    if(@user.update_attributes(update_options))
      flash[:success] = "Update profile Successful !"
      redirect_to edit_user_path(@user)
    else
      render :edit
    end
  end

  def change_password
    puts params
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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :old_password, :new_password, :new_password_confirmation)
  end

  def change_password_params
    params.require(:user).permit()
  end

  def user_update_params
    params.require(:user).permit(:name, :password)
  end
end
