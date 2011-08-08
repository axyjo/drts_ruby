Map.bar = Map.bar || {}

Map.bar.init = ->
  Map.bar._ = $ "#map_bar"
  Map.bar.icon = $(".map_control_bartoggle").find "a.iconic"

Map.bar.toggle = ->
  Map.bar._.fadeToggle ->
    Map._.width $(window).width()-Map.bar.width()
    Map.bar.icon.toggleClass "fullscreen"
    Map.bar.icon.toggleClass "exit-fullscreen"

Map.bar.width = ->
  if Map.bar._.is ':visible'
    Map.bar._.width()
  else
    0

Map.bar.position = (e) ->
  offset = Map.viewport._.offset()

  # Set x_val and y_val equal to the distance from the top-left of the
  # image layer.
  x_val = e.pageX - offset.left
  y_val = e.pageY - offset.top

  # Mod these values by the map size at the current zoom level.
  mapWidth = Map.tileSize * Map.maxTiles
  x = x_val % mapWidth
  if x <= 0
    x += mapWidth
  y = y_val % mapWidth
  if y <= 0
    y += mapWidth

  # Multiply x_val and y_val by a scaling factor dependent on the current zoom
  # level. Then, get the ceiling value because the possible values range from 1
  # to the game map width.
  scale = Math.pow(2, Map.zoom+3)
  x = Math.ceil(x/scale)
  y = Math.ceil(y/scale)
  x_val = Math.ceil(x_val/scale)
  y_val = Math.ceil(y_val/scale)

  $("#map_position").html(x + ", " + y)
  {x: x, y: y, xTor: x_val, yTor: y_val}
