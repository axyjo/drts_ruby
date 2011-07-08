Chat = Chat || {}

Chat.init = ->
  Chat.client = new Faye.Client 'http://localhost:9292/faye'
  global_subscription = Chat.client.subscribe '/global_chat', (msg) ->
   console.log(msg)

window.Chat = Chat
