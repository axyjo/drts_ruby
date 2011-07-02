class SessionsController < ApplicationController
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
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid username or password"
      render "new", :layout => false
    end
  end

  def destroy
    session[:user_id] = nil
    render :nothing => true, :notice => "Logged out!"
  end
end
