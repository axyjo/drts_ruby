class ChatsController < ApplicationController
  def new
    if params[:msg] != ''
      message = ActionController::Base.helpers.sanitize params[:msg]
      broadcast '/global_chat', {'user' => current_user.username, 'msg' => message}
      render
    end
  end
end
