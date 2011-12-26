Game.debug = Game.debug || {}

Game.debug.entityCount = 0

Game.debug.getTiming = (current) ->
  timing = window.performance.timing
  array =
    dns: timing.domainLookupEnd - timing.domainLookupStart,
    connect: timing.connectEnd - timing.connectStart,
    ttfb: timing.responseStart - timing.connectEnd,
    basePage: timing.responseEnd - timing.responseStart,
    frontEnd: timing.loadEventStart - timing.responseEnd,
    latency: current - timing.navigationStart


Game.debug.init = ->
  if window.performance and window.performance.timing and window.localStorage
    store = window.localStorage
    obj = Game.debug.getTiming new Date().getTime()
    count = store.getItem 'navigationTimingCount' || 0
    count = 0 if isNaN count
    count = parseInt count
    for metric, value of obj
      old_val = store.getItem 'navigationTiming_'+metric || 0
      val = (old_val*count + value)/(count + 1)
      store.setItem 'navigationTiming_'+metric, val
    store.setItem 'navigationTimingCount', count+1
