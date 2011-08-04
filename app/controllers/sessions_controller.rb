class SessionsController < ApplicationController
  skip_before_filter :check_empire
  skip_before_filter :check_path, :only => :create

  def new
    render :layout => false
  end

  def create
    user = User.find_by_username(params[:username])
    if user == nil
      user = User.find_by_email(params[:email])
    end
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Logged in!"
      render
    else
      flash[:error] = "Invalid username or password"
      render "new", :layout => false
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Logged out!"
    render
  end
end
