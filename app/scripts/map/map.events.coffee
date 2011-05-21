Game.map.events = Game.map.events || {}

Game.map.events.init = ->
  # Mouse events.
  $("#map").bind("click", Game.map.events.click)
  $("#map").bind("dblclick", Game.map.events.dblclick)
  $("#map").bind("mousedown", Game.map.events.mousedown)
  $("#map").bind("mousemove", Game.map.events.mousemove)
  # Instead of binding the mouseup event to the map, bind it to the document
  # so that even if the mouse is let go when the cursor is ourside of the
  # div, the map will not drag again when the cursor is brought in to the
  # div again.
  $(document).bind("mouseup", this.mouseup)  
  # Window events.
  $(window).resize(Game.map.events.resize)

Game.map.events.click = (e) ->
  position = Game.map.bar.position(e)
  Game.map.bar.populate(position)

Game.map.events.dblclick = (e) ->
  Game.map.zoomIn()
  Game.map.bar.position(e)


Game.map.events.mousedown = (e) ->
  Game.map.drag.start(e)
  Game.map.viewport.moveCursor()
  # The following statement exists in order to prevent the user's browser from
  # dragging the tile image like a conventional picture.
  false


Game.map.events.mousemove = (e) ->
  # First check if we're in the middle of a dragging gesture.
  if Game.map.drag.dragging
    Game.map.drag.move(e)
    # Move the viewport, based on the current change in positon.
    Game.map.viewport.moveDelta(Game.map.drag.dragDeltaLeft, Game.map.drag.dragDeltaTop, true)
  Game.map.bar.position(e)


Game.map.events.mouseup = (e) -> 
  if Game.map.drag.dragging
    Game.map.drag.end()
  Game.map.viewport.clearCursor()

Game.map.events.resize = -> 
  $("#map_viewport").width($(window).width()-$("#map_bar").width())
  $("#map_viewport").height($(window).height())
  $("#map").offset({left: $(window).width() - $("#map_viewport").width()})
  $("#map_bar").height($("#map_viewport").height())
  $("#map_bar").width($(window).width() - $("#map_viewport").width())
  $("#map_position").offset({top: $("#map_bar").height()})