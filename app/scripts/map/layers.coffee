Map = Map || {}

Map.layers = Map.layers || {}

Map.layers.init = -> 
  # Lock for the checkAll() function so that we don't check too many times
  # on a particular event trigger.
  Map.layers.checkLock = false
  Map.layers.tilesets = Drupal.settings.tilesets

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
