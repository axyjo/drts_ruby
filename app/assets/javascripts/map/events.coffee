Map.events = Map.events || {}

Map.events.init = ->
  # Mouse events.
  Map._.bind("click", Map.events.click)
  Map._.bind("dblclick", Map.events.dblclick)
  Map._.bind("mousedown", Map.events.mousedown)
  Map._.bind("mousemove", Map.bar.position)
  # A drag that has already started shouldn't be interrupted.
  $(document).bind("mousemove", Map.events.mousemove)
  # Instead of binding the mouseup event to the map, bind it to the document
  # so that even if the mouse is let go when the cursor is ourside of the
  # div, the map will not drag again when the cursor is brought in to the
  # div again.
  $(document).bind("mouseup", this.mouseup)
  # Window events.
  $(window).resize(Map.events.resize)
  # Keyboard shortcuts.
  $(document).keydown (e) ->
    switch e.which
      when 187, 107, 43 then Map.zoomIn()
      when 189, 61, 109, 45 then Map.zoomOut()
      when 37  then Map.pan(25, 0)
      when 38  then Map.pan(0, 25)
      when 39  then Map.pan(-25, 0)
      when 40  then Map.pan(0, -25)
  # Map controls.
  $(".map_control_zoom").find("a.plus").click ->
    Map.zoomIn()
  $(".map_control_zoom").find("a.minus").click ->
    Map.zoomOut()

Map.events.click = (e) ->
  Map.bar.position(e)

Map.events.dblclick = (e) ->
  Map.zoomIn()
  Map.bar.position(e)

Map.events.mousedown = (e) ->
  Map.drag.start(e)
  Map.viewport._.css("cursor","move")
  # The following statement exists in order to prevent the user's browser from
  # dragging the tile image like a conventional picture.
  false

Map.events.mousemove = (e) ->
  # First check if we're in the middle of a dragging gesture.
  if Map.drag.dragging
    Map.drag.move(e)
    # Move the viewport, based on the current change in positon.
    Map.viewport.moveDelta(Map.drag.dragDeltaLeft, Map.drag.dragDeltaTop, false)

Map.events.mouseup = (e) ->
  if Map.drag.dragging
    Map.drag.end()
    Map.viewport._.css("cursor", "")

Map.events.resizeCheck = ->
  Map.events.resize()
  Map.layers.checkAll()

Map.events.resize = ->
  Map._.width $(window).width()-Map.bar.width()
  Map._.height $(window).height() - Game.navbar.height()
  Map._.offset {top: Game.navbar.height()}
  Map.bar._.height Map._.height()
  Map.bar._.offset {top: Game.navbar.height(), left: $(window).width() - Map.bar.width()}
