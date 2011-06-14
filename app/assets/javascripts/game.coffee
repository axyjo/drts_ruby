Game = Game || {}

# Extend the Game namespace to include the modal dialog.

Game.modal = Game.modal || {}

Game.modal.init = ->
  $("a").bind("click", Game.modal.click)

Game.modal.click = (e) ->
  Game.modal.fetch e.target.href
  false

Game.modal.fetch = (url) ->
  $.getJSON url, Game.modal.parseJSON, "json"
  Game.modal.show()

Game.modal.parseJSON = (data) ->
  if data?
    if typeof data == 'string'
      data = jQuery.parseJSON data
    $("#modal-header").replace(data.header)
    $("#modal-content").replace(data.content)

Game.modal.show = ->
  $("#modal").show()

Game.modal.hide = ->
  $("#modal").hide()

window.Game = Game
