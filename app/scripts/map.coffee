Map = Map || {}

# Create the base map namespace.

Map.init = ->
  Map.maxTiles = 0
  Map.tileSize = 256
  Map.mapSize = 512
  Map.defaultZoom = 3
  Map.borderCache = 1
  Map.layers.init()
  Map.events.init()
  Map.viewport.init()
  Map.resetZoom()
  window.setInterval(Map.events.resize, '100')
  window.setInterval(Map.events.resize, '2000')
  Map.checkBounds()
  Map.layers.checkAll()

Map.coordinateLength = ->
  # Resolutions are zoom levels to pixels per coordinate. Zoom level 0 is
  # zoomed all the way in, while zoom level 7 is zoomed all the way out.
  # Answers the question: How long is one side of the square allocated to a
  # coordinate (in pixels)? Response is equivalent to the following code:
  # var resolutions = {0: 1,1: 2,2: 4, 3:8, 4:16, 5:32, 6:64, 7:128};
  return Math.pow(2, this.zoom)

Map.resetZoom = ->
  zoom = Map.defaultZoom
  this.setZoom(zoom)

Map.setZoom = (z) ->
  if z < 0
    z = 0
  else if z > 7
    z = 7
  this.zoom = z;
  totalSize = this.mapSize* this.coordinateLength()
  Map.maxTiles = totalSize/this.tileSize
  $("#map_viewport").width(totalSize)
  $("#map_viewport").height(totalSize)
  this.layers.checkAll()

Map.zoomIn = ->
  this.setZoom(this.zoom - 1)
  console.log("New zoom: ",this.zoom)

Map.zoomOut = ->
  this.setZoom(this.zoom + 1)
  console.log("New zoom: ",this.zoom)

Map.checkBounds = ->
  viewport = $("#map_viewport")
  totalSize = this.mapSize* this.coordinateLength()
  left_offset = 0 + $("#map_bar").width()
  top_offset = 0

  if viewport.offset().left - left_offset > 0
    viewport.offset(left: left_offset)
  else if viewport.offset().left < viewport.width() - totalSize + left_offset
    viewport.offset(left: viewport.width() - totalSize + left_offset)

  if viewport.offset().top + top_offset > 0
    viewport.offset(top: 0 + top_offset)
  else if viewport.offset().top < viewport.height() - totalSize + top_offset
    viewport.offset(top: viewport.height() - totalSize + top_offset)

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

# Extend the map namespace by including layer functions.

Map.layers = Map.layers || {}

Map.layers.init = -> 
  # Lock for the checkAll() function so that we don't check too many times
  # on a particular event trigger.
  Map.layers.checkLock = false
  Map.layers.tilesets = ["base"]

Map.layers.checkAll = ->
  true while Map.layers.checkLock
  if not Map.layers.checkLock
    Map.layers.checkLock = true
    Map.layers.check tileset for tileset in Map.layers.tilesets
  Map.layers.checkLock = false

Map.layers.check = (type) ->
  visTiles = Map.layers.getVisibleTiles()
  visTilesMap = new Array()
  fetchTiles = new Array()

  for tileArr in visTiles
    do ->
      tileName = type + '-' + tileArr.xPos + '-' + tileArr.yPos + '-' + Map.zoom
      visTilesMap[tileName] = tileArr
      $("#" + tileName).remove()
      cached = $("#map_viewport").data tileName
      if cached? and cached.html?
        $("#map_viewport").append cached.html
      else
        fetchTiles.push tileName

  url = "http://" + document.location.host + "/tiles?fetch=true"
  fetch = false

  for tile in fetchTiles
    url = url + "&t[]=" + encodeURIComponent(tile)
    fetch = true

  if fetch
    $.getJSON url, (data)->
      if data?
        for tile in data
          if tile? and tile.html?
            $("#map_viewport").append tile.html
            $("#map_viewport").data tile.id, tile
      return true
    ,"json"

  $(window).triggerHandler 'resize'

Map.layers.clear = (type) ->
  $("#map_viewport img").each (i) ->
    if $(this).hasClass(type)
      $(this).remove()

Map.layers.clearAll = ->
  Map.layers.clear tileset for tileset in Map.layers.tilesets

Map.layers.getVisibleTiles = ->
  # Get the current offset from the 0, 0 position.
  mapX = Map.viewport.left()
  mapY = Map.viewport.top()

  # Get the first tile that should be visible. The border_cache variable
  # exists as the script should download border_cache tiles beyond the
  # visible border.
  startX = Math.abs(Math.floor(mapX / Map.tileSize)) - Map.borderCache
  startY = Math.abs(Math.floor(mapY / Map.tileSize)) - Map.borderCache
  startX = Math.max(0, startX)
  startY = Math.max(0, startY)
  
  # Get the number of tiles that are completely visible. The border_cache
  # variable exists so that the script downloads partially visible tiles as
  # well. This value does not change unless the viewport size is changed.
  tilesX = Math.ceil($("#map_viewport").width() / Map.tileSize) + Map.borderCache
  tilesY = Math.ceil($("#map_viewport").height() / Map.tileSize) + Map.borderCache
  
  endX = startX + tilesX
  endY = startY + tilesY
  endX = Math.min(Map.maxTiles - 1, endX)
  endY = Math.min(Map.maxTiles - 1, endY)

  # Generate the list of visible tiles based on the above variables.
  visibleTiles = []
  counter = 0
  for x in [startX..endX]
    do ->
      for y in [startY..endY]
        do ->
          tile = xPos: x, yPos: y
          visibleTiles[counter++] = tile
  return visibleTiles

# Extend the map namespace by including viewport functions.

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

# Extend the map namespace by including the map bar functions.

Map.bar = Map.bar || {}

Map.bar.init = ->

Map.bar.populate = (position) -> 
  if position.x > 0 and position.y > 0 and position.x <= Map.mapSize and position.y <= Map.mapSize 
    if this.ajax_request?
      this.ajax_request.abort();
    # Store the hover/click request in a variable so that it can be easily
    # aborted.
    this.ajax_request = $.ajax(
      type: "GET"
      url: "?q=map_click/" + Math.floor(position.x) + '/' + Math.floor(position.y)
      success: (data) -> 
        $('#map_data').html(data);
        $(window).triggerHandler('resize');
    )

Map.bar.position = (e) -> 
  # Caclulate the distance the viewport has been offset by to account for
  # items to its left and top. We cannot simply subtract the viewport's
  # width from the window's width (and the same for height), as then items
  # to the right and top would be counted again, causing an over-correction.
  displacementX = $("#map_bar").width()
  displacementY = 0

  offset = $("#map_viewport").offset();
  # Using displacements from origin calculated above, change the values.
  offset.left -= displacementX
  offset.top -= displacementY

  # Set x_val and y_val equal to the distance from the top-left of the
  # image layer.
  x_val = e.pageX - displacementX - offset.left
  y_val = e.pageY - displacementY - offset.top

  # Change x_val and y_val such that the script takes into consideration
  # the current zoom level and the tile size. First, divide by the length
  # of the coordinate at the current zoom level. Then, get the ceiling value
  # because the possible values range from 1 to mapSize.
  x_val = Math.ceil(x_val/Map.coordinateLength())
  y_val = Math.ceil(y_val/Map.coordinateLength())

  position = {x: x_val, y: y_val}
  $("#map_position").html(position.x + ", " + position.y)
  return position

# Extend the map namespace by including the drag functions.

Map.drag = Map.drag || {}

Map.dragging = false

Map.drag.start = (e) ->
  # Get the starting position of the drag gesture.
  this.dragStartLeft = e.clientX
  this.dragStartTop = e.clientY
  # The difference between the dragStart position and dragEnd position will be
  # used to change the offset of the viewport.
  this.dragging = true

Map.drag.move = (e) ->
  # Update the dragEnd variables with the current mouse position.
  this.dragEndLeft = e.clientX;
  this.dragEndTop = e.clientY;
  # Caculate change in position.
  this.dragDeltaLeft = this.dragEndLeft - this.dragStartLeft;
  this.dragDeltaTop = this.dragEndTop - this.dragStartTop;
  # Reset the starting coordinates.
  this.dragStartLeft = this.dragEndLeft;
  this.dragStartTop = this.dragEndTop;
  # Check for map viewport bounding box.
  Map.checkBounds();


Map.drag.end = ->
  this.dragging = false
  # Check for map viewport bounding box.
  Map.checkBounds()
  # Check layers for newly loaded tiles.
  Map.layers.checkAll()

window.Map = Map