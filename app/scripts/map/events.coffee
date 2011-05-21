Map = Map || {}

Map.events = Map.events || {}

Map.events.init = ->
  # Mouse events.
  $("#map").bind("click", Map.events.click)
  $("#map").bind("dblclick", Map.events.dblclick)
  $("#map").bind("mousedown", Map.events.mousedown)
  $("#map").bind("mousemove", Map.events.mousemove)
  # Instead of binding the mouseup event to the map, bind it to the document
  # so that even if the mouse is let go when the cursor is ourside of the
  # div, the map will not drag again when the cursor is brought in to the
  # div again.
  $(document).bind("mouseup", this.mouseup)  
  # Window events.
  $(window).resize(Map.events.resize)

Map.events.click = (e) ->
  position = Map.bar.position(e)
  Map.bar.populate(position)

Map.events.dblclick = (e) ->
  Map.zoomIn()
  Map.bar.position(e)


Map.events.mousedown = (e) ->
  Map.drag.start(e)
  Map.viewport.moveCursor()
  # The following statement exists in order to prevent the user's browser from
  # dragging the tile image like a conventional picture.
  false


Map.events.mousemove = (e) ->
  # First check if we're in the middle of a dragging gesture.
  if Map.drag.dragging
    Map.drag.move(e)
    # Move the viewport, based on the current change in positon.
    Map.viewport.moveDelta(Map.drag.dragDeltaLeft, Map.drag.dragDeltaTop, true)
  Map.bar.position(e)


Map.events.mouseup = (e) -> 
  if Map.drag.dragging
    Map.drag.end()
  Map.viewport.clearCursor()

Map.events.resize = -> 
  $("#map_viewport").width($(window).width()-$("#map_bar").width())
  $("#map_viewport").height($(window).height())
  $("#map").offset({left: $(window).width() - $("#map_viewport").width()})
  $("#map_bar").height($("#map_viewport").height())
  $("#map_bar").width($(window).width() - $("#map_viewport").width())
  $("#map_position").offset({top: $("#map_bar").height()})
