Notifications = Notifications || {}

Notifications.init = ->
  notifications_client = Chat.client.subscribe '/broadcast', (msg) ->
    msg.type = 'info'
    Notifications.trigger msg

Notifications.trigger = (msg) ->
  element = $("<div></div>").addClass("notification").addClass(msg.type).hide()
  element.append("<h3>" + msg.title + "</h3>")
  element.append("<p>" + msg.body + "</p>")
  element.width Map._.width()
  $("body").append(element)
  $(element).fadeIn()
  element.click ->
    $(this).fadeOut "slow", ->
      $(this).remove()

window.Notifications = Notifications
