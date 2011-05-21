Game.map = Game.map || {};

Game.map.init = ->
  Game.map.maxTiles = 0
  Game.map.tileSize = 256
  Game.map.mapSize = 512
  Game.map.defaultZoom = 3
  Game.map.borderCache = 1
  Game.map.layers.init()
  Game.map.events.init()
  Game.map.viewport.init()
  Game.map.resetZoom()
  window.setInterval(Game.map.events.resize, '100')
  window.setInterval(Game.map.events.resize, '2000')
  Game.map.checkBounds()
  Game.map.layers.checkAll()

Game.map.coordinateLength = ->
  # Resolutions are zoom levels to pixels per coordinate. Zoom level 0 is
  # zoomed all the way in, while zoom level 7 is zoomed all the way out.
  # Answers the question: How long is one side of the square allocated to a
  # coordinate (in pixels)? Response is equivalent to the following code:
  # var resolutions = {0: 1,1: 2,2: 4, 3:8, 4:16, 5:32, 6:64, 7:128};
  return Math.pow(2, this.zoom)

Game.map.resetZoom = ->
  zoom = Game.map.defaultZoom
  this.setZoom(zoom)


Game.map.setZoom = (z) ->
  if z < 0
    z = 0
  else if z > 7
    z = 7
  this.zoom = z;
  totalSize = this.mapSize* this.coordinateLength()
  Game.map.maxTiles = totalSize/this.tileSize
  $("#map_viewport").width(totalSize)
  $("#map_viewport").height(totalSize)
  this.layers.checkAll()

Game.map.zoomIn = ->
  this.setZoom(this.zoom - 1)
  console.log("New zoom: ",this.zoom)

Game.map.zoomOut = ->
  this.setZoom(this.zoom + 1)
  console.log("New zoom: ",this.zoom)

Game.map.checkBounds = ->
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