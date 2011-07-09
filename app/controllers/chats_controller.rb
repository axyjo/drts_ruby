class ChatsController < ApplicationController
  def new
    broadcast '/global_chat', {'user' => current_user.username, 'msg' => params[:msg]}
    render :text => 'success'
  end
end
