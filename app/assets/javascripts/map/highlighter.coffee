Map.highlighter = Map.highlighter || {}

#TODO: Make this work with toroidal.

Map.highlighter.init = ->
  Map.highlighter._ = $ "#map_highlight"
  Map.highlighter.factor = 8*Math.pow(2, Map.defaultZoom)
  Map.highlighter.rescale()

Map.highlighter.zoom = ->
  Map.highlighter.factor = 8*Math.pow(2, Map.zoom)
  Map.highlighter.rescale()

Map.highlighter.rescale = ->
  Map.highlighter._.width Map.highlighter.factor - 4
  Map.highlighter._.height Map.highlighter.factor - 4

Map.highlighter.reposition = (value) ->
  (value-1)*Map.highlighter.factor

Map.highlighter.activate = (pos) ->
  Map.highlighter._.offset {left: this.reposition(pos.x) + Map.viewport.left(), top: this.reposition(pos.y) + Map.viewport.top()}
  Map.highlighter._.css "border", "2px #000 solid"
