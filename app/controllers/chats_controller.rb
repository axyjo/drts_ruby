class ChatsController < ApplicationController
  def new
    message = ActionController::Base.helpers.sanitize params[:msg]
    message.strip!
    if message != ''
      broadcast '/global_chat', {'user' => current_user.username, 'msg' => message}
      render
    end
  end
end
