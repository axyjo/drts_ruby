Map = Map || {}

Map.viewport = Map.viewport || {}

Map.viewport.init = ->
  Map.viewport.animateMove = true

Map.viewport.top = ->
  return $("#map_viewport").offset().top

Map.viewport.left = ->
  return $("#map_viewport").offset().left

Map.viewport.moveCursor = ->
  return $("#map_viewport").css("cursor","move")

Map.viewport.clearCursor = ->
  return $("#map_viewport").css("cursor", "")

Map.viewport.moveDelta = (dLeft, dTop, noAnimate) ->
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
  Map.checkBounds()
  # Check layers for newly loaded tiles.
  Map.layers.checkAll()
  
  console.log(this.left(), this.top())
