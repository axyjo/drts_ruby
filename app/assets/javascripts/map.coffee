Map = Map || {}

Map.init = ->
  Map._ = $ "#map"
  if Map._.length != 0
    Map.bar.init()
    Map.events.init()
    Map.highlighter.init()
    Map.infobox.init()
    Map.layers.init()
    Map.viewport.init()
    Map.resetZoom()
    Map.viewport.move(0, 0)

Map.resetZoom = ->
  this.setZoom(Map.defaultZoom)

Map.setZoom = (z) ->
  this.zoom = this._limitZoom z
  Map.maxTiles = Math.pow(2, this.zoom+2)
  this.layers.clearAll()
  this.layers.checkAll()
  Map.highlighter.zoom()

Map.zoomIn = ->
  this.setZoom(this.zoom + 1)

Map.zoomOut = ->
  this.setZoom(this.zoom - 1)

Map.setView = (center, zoom) ->
  #to implement.

Map.panTo = (center) ->
  this.setView center, this.zoom

Map.pan = (x, y) ->
  Map.viewport.moveDelta x, y, false
  Map.layers.checkAll()

Map._limitZoom = (z) ->
  min = 0
  max = Map.maxZoom
  Math.max(min, Math.min(max, z))

window.Map = Map
