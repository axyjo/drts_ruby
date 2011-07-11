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
  # Keyboard shortcuts.
  $(document).keydown (e) ->
    switch e.which
      when 187 then Map.zoomIn()
      when 189 then Map.zoomOut()
      when 37  then Map.pan(25, 0)
      when 38  then Map.pan(0, 25)
      when 39  then Map.pan(-25, 0)
      when 40  then Map.pan(0, -25)

Map.events.click = (e) ->
  Map.bar.position(e)

Map.events.dblclick = (e) ->
  Map.zoomIn()
  Map.bar.position(e)

Map.events.mousedown = (e) ->
  Map.drag.start(e)
  $("#map_viewport").css("cursor","move")
  # The following statement exists in order to prevent the user's browser from
  # dragging the tile image like a conventional picture.
  false

Map.events.mousemove = (e) ->
  # First check if we're in the middle of a dragging gesture.
  if Map.drag.dragging
    Map.drag.move(e)
    # Move the viewport, based on the current change in positon.
    Map.viewport.moveDelta(Map.drag.dragDeltaLeft, Map.drag.dragDeltaTop, false)
  Map.bar.position(e)

Map.events.mouseup = (e) ->
  if Map.drag.dragging
    Map.drag.end()
    $("#map_viewport").css("cursor", "")

Map.events.resize = ->
  $("#map").width($(window).width()-$("#map_bar").width())
  $("#map").height($(window).height() - Game.navbar.height())
  $("#map").offset({top: Game.navbar.height()})
  $("#map_bar").height($("#map").height())
  $("#map_bar").offset({top: Game.navbar.height(), left: $(window).width() - $("#map_bar").width()})
