Game = Game || {}

# Extend the Game namespace to include the modal dialog.

Game.modal = Game.modal || {}

Game.modal.init = ->
  $("a .modal").bind("click", Game.modal.click)

Game.modal.click = (e) ->
  console.log e.target.href
  false

window.Game = Game
