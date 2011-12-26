Game = Game || {}

window.Game = Game

$(document).ajaxError (e, req, settings) ->
  msg =
    title: 'An error occurred.'
    body: req.responseText
    type: 'error'
  Notifications.trigger msg
