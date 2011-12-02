class Point
  constructor: (x, y, round) ->
    this.x = if round then Math.round(x) else x
    this.y = if round then Math.round(y) else y

  clone: ->
    new Point this.x, this.y

  add: (point) ->
    this.clone()._add point

  _add: (point) ->
    this.x += point.x
    this.y += point.y
    this

  subtract: (point) ->
    this.clone()._subtract point

  _subtract: (point) ->
    this.x -= point.x
    this.y -= point.y
    this

  multiplyBy: (num, round) ->
    new Point this.x*num, this.y*num, round

  divideBy: (num, round) ->
    new Point this.x/num, this.y/num, round

  distanceTo: (point) ->
    x = point.x - this.x
    y = point.y - this.y
    Math.sqrt(x*x + y*y)

  clone: ->
    new Point this.x, this.y

  round: ->
    this.clone()._round()

  _round: ->
    this.x = Math.round(this.x)
    this.y = Math.round(this.y)
    this

  toString: ->
    'Point(' + this.x + ', ' + this.y + ')'

