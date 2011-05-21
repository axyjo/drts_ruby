Game.map.bar = Game.map.bar || {}

Game.map.bar.init = ->

Game.map.bar.populate = (position) -> 
  if position.x > 0 and position.y > 0 and position.x <= Game.map.mapSize and position.y <= Game.map.mapSize 
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

Game.map.bar.position = (e) -> 
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
  x_val = Math.ceil(x_val/Game.map.coordinateLength())
  y_val = Math.ceil(y_val/Game.map.coordinateLength())

  position = {x: x_val, y: y_val}
  $("#map_position").html(position.x + ", " + position.y)
  return position