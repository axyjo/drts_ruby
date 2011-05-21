Game.map.layers = Game.map.layers || {}

Game.map.layers.init = -> 
  # Lock for the checkAll() function so that we don't check too many times
  # on a particular event trigger.
  Game.map.layers.checkLock = false
  Game.map.layers.tilesets = Drupal.settings.tilesets

Game.map.layers.checkAll = ->
  true while Game.map.layers.checkLock
  if not Game.map.layers.checkLock
    Game.map.layers.checkLock = true
    Game.map.layers.check tileset for tileset in Game.map.layers.tilesets
  Game.map.layers.checkLock = false

Game.map.layers.check = (type) ->
  visTiles = Game.map.layers.getVisibleTiles()
  visTilesMap = new Array()
  fetchTiles = new Array()

  for tileArr in visTiles
    do ->
      tileName = type + '-' + tileArr.xPos + '-' + tileArr.yPos + '-' + Game.map.zoom
      visTilesMap[tileName] = tileArr
      $("#" + tileName).remove()
      cached = $("#map_viewport").data tileName
      if cached? and cached.html?
        $("#map_viewport").append cached.html
      else
        fetchTiles.push tileName

  url = Drupal.settings.basePath + "?q=tiles"
  fetch = false

  for tile in fetchTiles
    url = url + "&tiles[]=" + encodeURIComponent(fetchTiles[tile])
    fetch = true

  if fetch
    $.getJSON url, (data)->
      if data?
        $.each data (index, value) ->
          if value? and value.html?
            $("#map_viewport").append value.html
            $("#map_viewport").data index value
    ,"json"

  $(window).triggerHandler 'resize'

Game.map.layers.clear = (type) ->
  $("#map_viewport img").each (i) ->
    if $(this).hasClass(type)
      $(this).remove()

Game.map.layers.clearAll = ->
  Game.map.layers.clear tileset for tileset in Game.map.layers.tilesets

Game.map.layers.getVisibleTiles = ->
  # Get the current offset from the 0, 0 position.
  mapX = Game.map.viewport.left()
  mapY = Game.map.viewport.top()

  # Get the first tile that should be visible. The border_cache variable
  # exists as the script should download border_cache tiles beyond the
  # visible border.
  startX = Math.abs(Math.floor(mapX / Game.map.tileSize)) - Game.map.borderCache
  startY = Math.abs(Math.floor(mapY / Game.map.tileSize)) - Game.map.borderCache
  startX = Math.max(0, startX)
  startY = Math.max(0, startY)
  
  # Get the number of tiles that are completely visible. The border_cache
  # variable exists so that the script downloads partially visible tiles as
  # well. This value does not change unless the viewport size is changed.
  tilesX = Math.ceil($("#map_viewport").width() / Game.map.tileSize) + Game.map.borderCache
  tilesY = Math.ceil($("#map_viewport").height() / Game.map.tileSize) + Game.map.borderCache
  
  endX = startX + tilesX
  endY = startY + tilesY
  endX = Math.min(Game.map.maxTiles - 1, endX)
  endY = Math.min(Game.map.maxTiles - 1, endY)

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