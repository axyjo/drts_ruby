class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  def broadcast(channel, data)
    message = {:channel => channel, :data => data}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
