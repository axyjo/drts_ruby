class ChatsController < ApplicationController
  def new
    puts current_user.username
    puts params[:msg]
    client = Faye::Client.new('http://localhost:9292/faye')
    require 'eventmachine'
    EM.run {
      client.publish('/global_chat', {'user' => current_user.username, 'msg' => params[:msg]})
    }
    render :text => 'success'
  end
end
