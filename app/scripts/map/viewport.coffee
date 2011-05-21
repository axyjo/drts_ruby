Game.map.viewport = Game.map.viewport || {};

Game.map.viewport.init = ->
  Game.map.viewport.animateMove = true

Game.map.viewport.top = ->
  return $("#map_viewport").offset().top

Game.map.viewport.left = ->
  return $("#map_viewport").offset().left

Game.map.viewport.moveCursor = ->
  return $("#map_viewport").css("cursor","move")

Game.map.viewport.clearCursor = ->
  return $("#map_viewport").css("cursor", "")

Game.map.viewport.moveDelta = (dLeft, dTop, noAnimate) ->
  left = this.left()
  top = this.top()
  left += dLeft
  top += dTop
  console.log("new vals", left, top)
  if this.animateMove and not noAnimate
    $("#map_viewport").animate(left: left, top: top)
  else
    $("#map_viewport").offset(left: left, top: top)

  # Check for map viewport bounding box.
  Game.map.checkBounds()
  # Check layers for newly loaded tiles.
  Game.map.layers.checkAll()
  
  console.log(this.left(), this.top())