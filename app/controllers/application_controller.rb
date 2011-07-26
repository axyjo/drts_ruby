class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  before_filter :check_empire

  def broadcast(channel, data)
    message = {:channel => channel, :data => data}
    uri = URI.parse(FAYE_URL)
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def check_empire
    @modal = @modal || ""
    if current_user
      if current_user.empire.nil?
        @modal = "/empire/list"
      end
    end
  end
end
