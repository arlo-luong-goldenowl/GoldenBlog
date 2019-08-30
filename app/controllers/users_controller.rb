class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    # Cannot signup with existing email except that email login from social network
    @user = User.new(user_params)
    is_exist = User.where(email: params[:user][:email], provider: nil).exists?
    if(is_exist)
      @user.errors.add(:base, :email_already_in_used, message: "This email already in use")
      render :new
    else
      if @user.save
        flash[:success] = "Signup Successful !"
        redirect_to root_path
      else
        render :new
      end
    end
  end

  def profile
    render :profile
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
