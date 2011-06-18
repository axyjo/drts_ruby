Game = Game || {}

# Extend the Game namespace by including the navbar functions.
Game.navbar = Game.navbar || {}

Game.navbar.height = ->
  $("#navbar").height()

# Extend the Game namespace to include the modal dialog.

Game.modal = Game.modal || {}

Game.modal.init = ->
  $("a").bind("click", Game.modal.click)
  # TODO: recognize any hashes already in the URL bar on load.

Game.modal.click = (e) ->
  Game.modal.fetch e.target.href
  window.location.hash = e.target.pathname.substr(1, e.target.pathname.length)
  false

Game.modal.fetch = (url) ->
  $.ajax(
    type: "GET"
    url: url
    success: (data) ->
      $("#modal").html(data)
    )
  Game.modal.show()

Game.modal.show = ->
  $("#modal").show()
  $("#modal-overlay").show()

Game.modal.hide = ->
  $("#modal").hide()
  $("#modal-overlay").hide()
  window.location.hash = ''

window.Game = Game
