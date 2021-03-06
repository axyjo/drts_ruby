Map.layers = Map.layers || {}

Map.layers.init = ->
  Map.layers.subdomainCount = 4
  Map.layers.tilesets =
    base:
      attribution: ["Akshay Joshi", "Nikhil Mahajan"]
      year: 2007
  Map.layers.attribution this.tilesets
  for tileset, data of this.tilesets
    $(".tile_pane").append("<div id='" + tileset + "_tiles'></div>")

Map.layers.attribution = (tilesets) ->
  div = $ ".map_attribution"
  div.empty()
  year = (new Date()).getFullYear()
  for tileset, data of tilesets
    str = " &copy; " + data.year + " - " + year + " "
    arr = data.attribution
    while arr.length isnt 0
      name = arr.shift()
      if arr.length is 1
        name += " and "
      else if  arr.length > 1
        name += ", "
      str += name
    str += "."
    div.append str
  div.append " All rights reserved. Iconic icon set by P.J. Onori."
  div.show()

Map.layers.checkAll = ->
  Map.layers.check tileset for tileset, data of this.tilesets

Map.layers.clearAll = ->
  Map.layers.clear tileset for tileset, data of this.tilesets

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
  sd = (tile.z + real_x + real_y) % Map.layers.subdomainCount
  host = "http://" + sd + ".zeus.akshayjoshi.com"
  tile_path = tile.type + "/" + tile.z + "/" + real_x + "/" + real_y + ".png"
  img.attr "id", tile.id
  img.attr "src", host + "/tiles/" + tile_path
  img.offset {top: tile.y * Map.tileSize, left: tile.x * Map.tileSize}
  img.bind "load", ->
    $(this).addClass "map_tiles_loaded"
  img

Map.layers.check = (type) ->
  visibleTiles = Map.layers.getTiles(type)
  $("#"+type+"_tiles").children().each (i, e) ->
    if(typeof visibleTiles[$(this).attr('id')] != "undefined")
      delete visibleTiles[$(this).attr('id')]
    else
      $(e).remove()
      Game.debug.entityCount--
  for k,v of visibleTiles
    do ->
      Map.viewport._.find("#"+type+"_tiles").append Map.layers.getTileHTML v
      Game.debug.entityCount++

Map.layers.clear = (type) ->
  div = Map.viewport._.find("#"+type+"_tiles")
  Game.debug.entityCount -= div.children().length
  div.empty()

Map.layers.getTiles = (type) ->
  visibleTiles = {}
  coords = Map.layers.getVisibleCoords()
  for c in coords
    do ->
      tile =
        id: type + '-' + c.x + '-' + c.y + '-' + Map.zoom
        x: c.x
        y: c.y
        z: Map.zoom
        type: type
      visibleTiles[tile.id] = tile
  visibleTiles

Map.layers.getVisibleCoords = ->
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
  visibleCoords = []
  counter = 0
  for x in [startX..endX]
    do ->
      for y in [startY..endY]
        do ->
          tile = x: x, y: y
          visibleCoords[counter++] = tile
  visibleCoords
