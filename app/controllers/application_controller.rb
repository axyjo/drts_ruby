class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_empire
  before_filter :check_path
  layout :layout

  def broadcast(channel, data)
    message = {:channel => channel, :data => data}
    uri = URI.parse(FAYE_URL)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def redirect(path)
    if request.fullpath != path
      redirect_to path
    end
  end

  private
  def check_empire
    if current_user
      if current_user.empire.nil?
        redirect empires_list_path
      end
    end
  end

  def check_path
    if(!request.xhr? && params[:controller] != "maps")
      redirect_to root_url
    end
  end

  def layout
    puts "layout"
    if(params[:action] == "view" && params[:controller] == "maps")
      "application"
    else
      false
    end
  end
end
