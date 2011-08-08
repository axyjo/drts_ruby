class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :check_empire
  before_filter :check_path

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
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def check_empire
    if current_user
      if current_user.empire.nil?
        redirect empires_list_path
      end
    end
  end

  def check_path
    render "maps/view" if !request.xhr?
  end
end
