Map.infobox = Map.infobox || {}

Map.infobox.init = ->
  Map.infobox._ = $ "#map_infobox"
  Map.infobox.sensitivity = 7
  Map.infobox.interval = 100
  Map.infobox.timeout = 0

Map.infobox.handleHover = (e, pos) ->
  Map.infobox.trigger e, pos

Map.infobox.trigger = (e, pos) ->
  Map.infobox._.html "called at " + pos.x + ", " + pos.y
