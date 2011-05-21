Game = Game || {}

Game.init = ->
  Game.map.init()

$(document).ready ->
  Game.init()
