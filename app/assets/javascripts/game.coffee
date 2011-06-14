Game = Game || {}

# Extend the Game namespace by including the navbar functions.
Game.navbar = Game.navbar || {}

Game.navbar.height = ->
  $("#navbar").height()

window.Game = Game
