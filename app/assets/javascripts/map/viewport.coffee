Map.viewport = Map.viewport || {}

Map.viewport.init = ->
  Map.viewport._ = $ "#map_viewport"
  Map.viewport.animateMove = true
  Map.events.resize()

Map.viewport.top = ->
  return Map.viewport._.offset().top

Map.viewport.left = ->
  return Map.viewport._.offset().left

Map.viewport.move = (left, top) ->
  Map.viewport._.offset(left: left, top: top)

Map.viewport.moveDelta = (dLeft, dTop, animate) ->
  left = this.left() + dLeft
  top = this.top() + dTop
  if this.animateMove and animate
    Map.viewport._.animate(left: left, top: top)
  else
    Map.viewport._.offset(left: left, top: top)
