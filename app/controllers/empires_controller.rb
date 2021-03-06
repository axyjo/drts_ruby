class EmpiresController < ApplicationController
  skip_filter :check_empire, :only => :choose

  def list
    @empires = Empire.find(:all)
  end

  def choose
    u = current_user
    if u && u.empire.nil?
      e = Empire.find(params[:id])
      if e.valid? && params[:id].to_i != 255
        u.empire = e
        u.save
        flash[:success] = "Successfully associated user with the " + e.name + " empire."
      else
        flash[:error] = "The empire chosen was not valid."
      end
    else
      flash[:error] = "Invalid user, or user already associated with an empire."
    end
    redirect_to root_url
  end
end
