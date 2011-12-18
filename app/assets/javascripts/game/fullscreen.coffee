fullScreenAPI =
  support: false
  isFullScreen: ->
    return false
  requestFullScreen: ->
  cancelFullScreen: ->
  fullScreenEventName: ""
  prefix: ""

browserPrefixes = ['webkit', 'moz', 'o', 'ms', 'khtml']

if (typeof document.cancelFullScreen) != 'undefined'
  fullScreenAPI.support = true
else
  for prefix in browserPrefixes
    fullScreenAPI.prefix = prefix
    if (typeof document[prefix+"CancelFullScreen"]) != 'undefined'
      fullScreenAPI.support = true
      break

if fullScreenAPI.support
  fullScreenAPI.fullScreenEventName = fullScreenAPI.prefix + "fullscreenchange"
  fullScreenAPI.isFullScreen = ->
    switch this.prefix
      when ""
        return document.fullScreen
      when "webkit"
        return document.webkitIsFullScreen
      else
        return document[this.prefix + "FullScreen"]

  fullScreenAPI.requestFullScreen = (el) ->
    if this.prefix == ""
      el.requestFullScreen()
    else
      el[this.prefix + "RequestFullScreen"]()
  fullScreenAPI.cancelFullScreen = (el) ->
    if this.prefix == ""
      document.cancelFullScreen()
    else
      document[this.prefix + "CancelFullScreen"]()

if typeof jQuery != 'undefined'
  jQuery.fn.requestFullScreen = ->
    this.each ->
      if fullScreenAPI.support
        fullScreenAPI.requestFullScreen(this)

window.fullScreenAPI = fullScreenAPI

