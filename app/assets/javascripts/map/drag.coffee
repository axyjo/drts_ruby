Map.drag = Map.drag || {}

Map.drag.start = (e) ->
  # Get the starting position of the drag gesture.
  this.dragStartLeft = e.clientX
  this.dragStartTop = e.clientY
  # The difference between the dragStart position and dragEnd position will be
  # used to change the offset of the viewport.
  this.dragging = true

  Map.infobox._.trigger "mapdragstart"

Map.drag.move = (e) ->
  # Caculate change in position. e.client[X,Y] are the current positions while
  # this.dragStart[Left,Top] are the initial positions.
  this.dragDeltaLeft = e.clientX - this.dragStartLeft
  this.dragDeltaTop = e.clientY - this.dragStartTop

  # Reset the starting coordinates.
  this.dragStartLeft = e.clientX
  this.dragStartTop = e.clientY

  #Check layers for newly loaded tiles.
  Map.layers.checkAll()

Map.drag.end = ->
  this.dragging = false
  # Check layers for newly loaded tiles.
  Map.layers.checkAll()

  Map.infobox._.trigger "mapdragend"
