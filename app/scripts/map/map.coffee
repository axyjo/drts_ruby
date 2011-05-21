Map = Map || {}

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
