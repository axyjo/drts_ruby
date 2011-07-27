class ChatsController < ApplicationController
  def new
    message = ActionController::Base.helpers.sanitize params[:msg]
    message = message.strip
    if message != ''
      if params[:type] == 'empire'
        channel = '/empire_' + current_user.empire_id.to_s + '_chat'
      else
        channel = '/global_chat'
      end

      broadcast channel, {'user' => current_user.username, 'msg' => message}
      render
    end
  end
end
