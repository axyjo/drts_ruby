class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_empire
  before_filter :check_path
  before_filter :check_modal
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
        session[:modal_path] = empires_list_path
      end
    end
  end

  def check_path
    path = request.fullpath.split('?')[0]
    if(!request.xhr? && path != '/' && request.get?)
      session[:modal_path] = path
      redirect_to root_url
    end
  end

  def check_modal
    @modal_path = session[:modal_path]
    session[:modal_path] = nil
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
