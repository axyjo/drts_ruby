Map.infobox = Map.infobox || {}

Map.infobox.init = ->
  Map.infobox._ = $ "#map_infobox"
  Map.infobox.sensitivity = 7
  Map.infobox.interval = 500
  Map.infobox.timeout = 0
  Map.infobox.pX = 0
  Map.infobox.pY = 0
  Map.infobox._.on "mapdragstart", ->
    Map.infobox._.removeClass('map_infobox_visible').addClass 'map_infobox_invisible'
  Map.infobox._.on "mapdragend", ->
    Map.infobox._.removeClass('map_infobox_invisible').addClass 'map_infobox_visible'

Map.infobox.handleHover = (e, pos) ->
  if Map.infobox.pX != pos.xTor || Map.infobox.pY != pos.yTor
    if Map.infobox.hoverTimer
      Map.infobox.hoverTimer = clearTimeout(Map.infobox.hoverTimer)
    Map.infobox._.removeClass('map_infobox_visible').addClass 'map_infobox_invisible'

    Map.infobox.hoverTimer = setTimeout("Map.infobox.trigger(" + JSON.stringify(pos) + ")", Map.infobox.interval)

    # Current position is actually past position now.
    Map.infobox.pX = pos.xTor
    Map.infobox.pY = pos.yTor

Map.infobox.trigger = (pos) ->
  $.parseJSON pos
  Map.infobox.request = $.ajax(
    type: "GET"
    url: "http://" + document.location.host + "/coordinates/" + pos.x + "/" + pos.y
    success: (data) ->
      Map.infobox._.html data
      Map.infobox._.offset {left: Map.highlighter.reposition(pos.xTor) + Map.viewport.left(), top: Map.highlighter.reposition(pos.yTor) + Map.viewport.top()}
      Map.infobox._.removeClass('map_infobox_invisible').addClass 'map_infobox_visible'
  )
