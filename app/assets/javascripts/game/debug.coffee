Game.debug = Game.debug || {}

Game.debug.entityCount = 0

Game.debug.getTiming = (current) ->
  timing = window.performance.timing
  array =
    dns: timing.domainLookupEnd - timing.domainLookupStart,
    connect: timing.connectEnd - timing.connectStart,
    ttfb: timing.responseStart - timing.connectEnd,
    responseLoad: timing.responseEnd - timing.responseStart,
    browserParse: timing.loadEventStart - timing.responseEnd,
    latency: current - timing.navigationStart

Game.debug.init = ->
  if window.performance and window.performance.timing and window.localStorage
    store = window.localStorage
    obj = Game.debug.getTiming new Date().getTime()
    for k, v of obj
      key = 'navigationTiming'+k.substr(0, 1).toUpperCase()+k.substr(1)
      old_val = store.getItem key || 0
      val = old_val * 0.8 + v * 0.2
      store.setItem key, val
