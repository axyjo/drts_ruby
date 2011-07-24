class UsersController < ApplicationController
  def new
    @user = User.new
    render :layout => false
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Signed up!"
      redirect_to root_url
    else
      render "new", :layout => false
    end
  end
end
