class ChatsController < ApplicationController
  def new
    if params[:msg] != ''
      broadcast '/global_chat', {'user' => current_user.username, 'msg' => params[:msg]}
      render
    end
  end
end
