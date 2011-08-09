Map.infobox = Map.infobox || {}

Map.infobox.init = ->
  Map.infobox._ = $ "#map_infobox"
  Map.infobox.sensitivity = 7
  Map.infobox.interval = 250
  Map.infobox.timeout = 0
  Map.infobox.pX = 0
  Map.infobox.pY = 0

Map.infobox.handleHover = (e, pos) ->
  if Map.infobox.pX != pos.xTor || Map.infobox.pY != pos.yTor
    if Map.infobox.hoverTimer
      Map.infobox.hoverTimer = clearTimeout(Map.infobox.hoverTimer)
    Map.infobox.hoverTimer = setTimeout(Map.infobox.trigger(e, pos), Map.infobox.interval)

    # Current position is actually past position now.
    Map.infobox.pX = pos.xTor
    Map.infobox.pY = pos.yTor

Map.infobox.trigger = (e, pos) ->
  Map.infobox.request = $.ajax(
    type: "GET"
    url: "http://" + document.location.host + "/coordinates/" + pos.x + "/" + pos.y
    success: (data) ->
      Map.infobox._.html "called at " + pos.x + ", " + pos.y
  )
