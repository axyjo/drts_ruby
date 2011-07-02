Map = Map || {}

# Create the base map namespace.

Map.init = ->
  Map.maxTiles = 0
  Map.tileSize = 256
  Map.mapSize = 8192
  Map.defaultZoom = 0
  Map.borderCache = 0
  Map.events.init()
  Map.layers.init()
  Map.viewport.init()
  Map.resetZoom()
  Map.viewport.move(0, 0)

Map.resetZoom = ->
  this.setZoom(Map.defaultZoom)

Map.setZoom = (z) ->
  if z < 0
    z = 0
  else if z > 4
    z = 4
  this.zoom = z
  Map.maxTiles = Math.pow(2, z+2)
  this.layers.checkAll()

Map.zoomIn = ->
  this.setZoom(this.zoom + 1)

Map.zoomOut = ->
  this.setZoom(this.zoom - 1)

Map.pan = (x, y) ->
  Map.viewport.moveDelta x, y, false
  Map.layers.checkAll()

# Extend the map namespace by including event handlers.

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

# Extend the map namespace by including layer functions.

Map.layers = Map.layers || {}

Map.layers.init = ->
  Map.layers.tilesets = ["base"]

Map.layers.checkAll = ->
  Map.layers.check tileset for tileset in Map.layers.tilesets

Map.layers.getTileHTML = (tile) ->
  # Calculate which tile we really want to load from the server.
  real_x = tile.x
  real_y = tile.y
  real_x += Map.maxTiles until real_x >= 0
  real_y += Map.maxTiles until real_y >= 0
  real_x = real_x % Map.maxTiles
  real_y = real_y % Map.maxTiles

  # Create and return the image object.
  img = $("<img class='map_tiles'></img>")
  tile_path = tile.type + "/" + tile.z + "/" + real_x + "/" + real_y + ".png"
  img.attr "id", tile.id
  img.attr "src", "http://" + document.location.host + "/tiles/" + tile_path
  img.offset {top: tile.y * Map.tileSize, left: tile.x * Map.tileSize}
  img

Map.layers.check = (type) ->
  visibleTiles = Map.layers.getVisibleTiles()
  for t in visibleTiles
    do ->
      tile =
        id: type + '-' + t.x + '-' + t.y + '-' + Map.zoom
        x: t.x
        y: t.y
        z: Map.zoom
        type: type
      $("#" + tile.id).remove()
      $("#map_viewport").append Map.layers.getTileHTML tile
  $(window).triggerHandler 'resize'

Map.layers.getVisibleTiles = ->
  # Get the offset for the top left position, accounting for other elements on
  # the page.
  realViewportLeft = $("#map").offset().left - Map.viewport.left()
  realViewportTop = $("#map").offset().top - Map.viewport.top()

  # Get the first tile that should be visible. The border_cache variable
  # exists as the script should download border_cache tiles beyond the
  # visible border.
  startX = Math.floor(realViewportLeft / Map.tileSize) - Map.borderCache
  startY = Math.floor(realViewportTop / Map.tileSize) - Map.borderCache

  # Get the number of tiles that are completely visible. The border_cache
  # variable exists so that the script downloads partially visible tiles as
  # well. This value does not change unless the viewport size is changed.
  tilesX = Math.ceil($("#map").width() / Map.tileSize) + Map.borderCache
  tilesY = Math.ceil($("#map").height() / Map.tileSize) + Map.borderCache

  endX = startX + tilesX
  endY = startY + tilesY

  # Generate the list of visible tiles based on the above variables.
  visibleTiles = []
  counter = 0
  for x in [startX..endX]
    do ->
      for y in [startY..endY]
        do ->
          tile = x: x, y: y
          visibleTiles[counter++] = tile
  return visibleTiles

# Extend the map namespace by including viewport functions.

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

# Extend the map namespace by including the map bar functions.

Map.bar = Map.bar || {}

Map.bar.position = (e) ->
  offset = $("#map_viewport").offset()

  # Set x_val and y_val equal to the distance from the top-left of the
  # image layer.
  x_val = e.pageX - offset.left
  y_val = e.pageY - offset.top

  # Mod these values by the map size at the current zoom level.
  mapWidth = Map.tileSize * Map.maxTiles
  x_val = x_val % mapWidth
  if x_val <= 0
    x_val += mapWidth
  y_val = y_val % mapWidth
  if y_val <= 0
    y_val += mapWidth

  # Multiply x_val and y_val by a scaling factor dependent on the current zoom
  # level. Then, get the ceiling value because the possible values range from 1
  # to the game map width.
  scale = Math.pow(2, Map.zoom+3)
  x_val = Math.ceil(x_val/scale)
  y_val = Math.ceil(y_val/scale)

  $("#map_position").html(x_val + ", " + y_val)
  {x: x_val, y: y_val}

# Extend the map namespace by including the drag functions.

Map.drag = Map.drag || {}

Map.drag.start = (e) ->
  # Get the starting position of the drag gesture.
  this.dragStartLeft = e.clientX
  this.dragStartTop = e.clientY
  # The difference between the dragStart position and dragEnd position will be
  # used to change the offset of the viewport.
  this.dragging = true

Map.drag.move = (e) ->
  # Caculate change in position. e.client[X,Y] are the current positions while
  # this.dragStart[Left,Top] are the initial positions.
  this.dragDeltaLeft = e.clientX - this.dragStartLeft
  this.dragDeltaTop = e.clientY - this.dragStartTop

  # Reset the starting coordinates.
  this.dragStartLeft = e.clientX
  this.dragStartTop = e.clientY

Map.drag.end = ->
  this.dragging = false
  # Check layers for newly loaded tiles.
  Map.layers.checkAll()

window.Map = Map
