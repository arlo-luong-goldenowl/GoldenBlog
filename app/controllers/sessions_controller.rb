class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if(user && user.authenticate(params[:session][:password]))
      log_in(user)
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "Welcome to my app"
      redirect_to profile_users_path
    else
      flash.now[:danger] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  def social_login
    user = User.from_omniauth(request.env['omniauth.auth'])
    log_in(user)
    remember(user)
    flash[:success] = "Welcome to my app"
    redirect_to profile_users_path
  end
end
