Game.map.drag = Game.map.drag || {}

Game.map.dragging = false

Game.map.drag.start = (e) ->
  # Get the starting position of the drag gesture.
  this.dragStartLeft = e.clientX
  this.dragStartTop = e.clientY
  # The difference between the dragStart position and dragEnd position will be
  # used to change the offset of the viewport.
  this.dragging = true

Game.map.drag.move = (e) ->
  # Update the dragEnd variables with the current mouse position.
  this.dragEndLeft = e.clientX;
  this.dragEndTop = e.clientY;
  # Caculate change in position.
  this.dragDeltaLeft = this.dragEndLeft - this.dragStartLeft;
  this.dragDeltaTop = this.dragEndTop - this.dragStartTop;
  # Reset the starting coordinates.
  this.dragStartLeft = this.dragEndLeft;
  this.dragStartTop = this.dragEndTop;
  # Check for map viewport bounding box.
  Game.map.checkBounds();


Game.map.drag.end = ->
  this.dragging = false
  # Check for map viewport bounding box.
  Game.map.checkBounds()
  # Check layers for newly loaded tiles.
  Game.map.layers.checkAll()