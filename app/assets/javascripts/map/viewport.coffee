Map.viewport = Map.viewport || {}

Map.viewport.init = ->
  Map.events.resize()
  Map.viewport.animateMove = true

Map.viewport.top = ->
  return $("#map_viewport").offset().top

Map.viewport.left = ->
  return $("#map_viewport").offset().left

Map.viewport.move = (left, top) ->
  $("#map_viewport").offset(left: left, top: top)

Map.viewport.moveDelta = (dLeft, dTop, animate) ->
  left = this.left() + dLeft
  top = this.top() + dTop
  if this.animateMove and animate
    $("#map_viewport").animate(left: left, top: top)
  else
    $("#map_viewport").offset(left: left, top: top)
