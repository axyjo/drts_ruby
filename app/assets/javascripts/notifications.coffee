Notifications = Notifications || {}

Notifications.init = ->
  notifications_client = Chat.client.subscribe '/broadcast', (msg) ->
    msg.type = 'info'
    Notifications.trigger msg
  $(".notification").fadeIn()
  $(document).delegate ".notification", "click",  ->
    $(this).fadeOut "slow", ->
      $(this).remove()

Notifications.trigger = (msg) ->
  element = $("<div></div>").addClass("notification").addClass(msg.type).hide()
  element.append("<h3>" + msg.title + "</h3>")
  element.append("<p>" + msg.body + "</p>")
  element.width '100%'
  $("body").append(element)
  $(element).fadeIn()

window.Notifications = Notifications
