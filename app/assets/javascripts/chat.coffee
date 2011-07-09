Chat = Chat || {}

Chat.init = ->
  Chat.client = new Faye.Client 'http://f48035e8.dotcloud.com/'
  global_subscription = Chat.client.subscribe '/global_chat', (msg) ->
   $("#global-chat-box").append("<div class='chat-message'><strong>" + msg.user + "</strong>: " + msg.msg + "</div>")

window.Chat = Chat
