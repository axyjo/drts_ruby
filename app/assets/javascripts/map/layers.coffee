Map.layers = Map.layers || {}

Map.layers.init = ->
  Map.layers.tilesets = ["base"]
  for tileset in Map.layers.tilesets
    $(".tile_pane").append("<div id='" + tileset + "_tiles'></div>")

Map.layers.checkAll = ->
  Map.layers.check tileset for tileset in Map.layers.tilesets

Map.layers.clearAll = ->
  Map.layers.clear tileset for tileset in Map.layers.tilesets

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
      Map.viewport._.find("#"+type+"_tiles").append Map.layers.getTileHTML tile
  $(window).triggerHandler 'resize'

Map.layers.clear = (type) ->
  Map.viewport._.find("#"+type+"_tiles").empty()

Map.layers.getVisibleTiles = ->
  # Get the offset for the top left position, accounting for other elements on
  # the page.
  realViewportLeft = Map._.offset().left - Map.viewport.left()
  realViewportTop = Map._.offset().top - Map.viewport.top()

  # Get the first tile that should be visible. The border_cache variable
  # exists as the script should download border_cache tiles beyond the
  # visible border.
  startX = Math.floor(realViewportLeft / Map.tileSize) - Map.borderCache
  startY = Math.floor(realViewportTop / Map.tileSize) - Map.borderCache

  # Get the number of tiles that are completely visible. The border_cache
  # variable exists so that the script downloads partially visible tiles as
  # well. This value does not change unless the viewport size is changed.
  tilesX = Math.ceil(Map._.width() / Map.tileSize) + Map.borderCache
  tilesY = Math.ceil(Map._.height() / Map.tileSize) + Map.borderCache

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
  visibleTiles
