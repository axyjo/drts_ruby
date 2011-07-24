Map = Map || {}

Map.init = ->
  Map._ = $ "#map"
  Map.maxTiles = 0
  Map.tileSize = 256
  Map.mapSize = 8192
  Map.defaultZoom = 0
  Map.borderCache = 0
  Map.bar.init()
  Map.events.init()
  Map.layers.init()
  Map.viewport.init()
  Map.resetZoom()
  Map.viewport.move(0, 0)

Map.resetZoom = ->
  this.setZoom(Map.defaultZoom)

Map.setZoom = (z) ->
  if z < 0
    z = 0
  else if z > 3
    z = 3
  this.zoom = z
  Map.maxTiles = Math.pow(2, z+2)
  this.layers.clearAll()
  this.layers.checkAll()

Map.zoomIn = ->
  this.setZoom(this.zoom + 1)

Map.zoomOut = ->
  this.setZoom(this.zoom - 1)

Map.pan = (x, y) ->
  Map.viewport.moveDelta x, y, false
  Map.layers.checkAll()

window.Map = Map
