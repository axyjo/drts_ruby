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
