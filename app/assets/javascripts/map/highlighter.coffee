Map.highlighter = Map.highlighter || {}

Map.highlighter.init = ->
  Map.highlighter._ = $ "#map_highlight"
  Map.highlighter.factor = 8*Math.pow(2, Map.defaultZoom)
  Map.highlighter.rescale()

Map.highlighter.zoom = ->
  Map.highlighter.factor = 8*Math.pow(2, Map.zoom)
  Map.highlighter.rescale()

Map.highlighter.rescale = ->
  Map.highlighter._.width Map.highlighter.factor - 2
  Map.highlighter._.height Map.highlighter.factor - 2

Map.highlighter.reposition = (value) ->
  (value-1)*Map.highlighter.factor

Map.highlighter.activate = (e, pos) ->
  Map.highlighter._.offset {left: this.reposition(pos.xTor) + Map.viewport.left(), top: this.reposition(pos.yTor) + Map.viewport.top()}
  Map.highlighter._.css "border", "1px #000 solid"
