Map.infobox = Map.infobox || {}

Map.infobox.init = ->
  Map.infobox._ = $ "#map_infobox"
  Map.infobox.sensitivity = 7
  Map.infobox.interval = 100
  Map.infobox.timeout = 0
