#= require ../core/abstract

class Point
  constructor: (@x,@y)->
  diff: (point)->
    new Point @x-point.x, @y-point.y

Number::clamp = (min,max)->
  if @valueOf() < min then min else if @valueOf() > max then max else @valueOf()

class UI.Range extends UI.Abstract
  @TAGNAME: 'range'

  _setValue: (percent)->
    range = Math.abs(@min-@max)
    @value = range*percent+@min

  initialize: ->
    @knob = @children[0]
    @knob.style.left = 0

    Object.defineProperty @, '_percent',
      get: -> Math.abs(@min-@value) / Math.abs(@min-@max)

    Object.defineProperty @, 'min',
      get: -> parseFloat @getAttribute('min')
      set: (value)->
        percent = @_percent
        @setAttribute 'min', parseFloat(value)
        @_setValue = percent

    Object.defineProperty @, 'max',
      get: -> parseFloat @getAttribute('max')
      set: (value)->
        percent = @_percent
        @setAttribute 'max', parseFloat(value)
        @_setValue = percent

    Object.defineProperty @, 'value',
      set: (value)->
        return if @value is value
        value = value.clamp(@min,@max)
        range = Math.abs(@min-@max)
        percent = (Math.abs(@min-value)/range)*100
        @knob.style.left = percent+"%"
        @fireEvent 'change'
        @value
      get: ->
        percent = parseFloat @knob.style.left
        range = Math.abs(@min-@max)
        range*(percent/100)+@min

    startPos = start = null

    getPosition = (e)->
      if e.touches
        new Point e.touches[0].pageX, e.touches[0].pageY
      else
        new Point e.pageX, e.pageY

    move = (e)=>
      e.preventDefault()
      diff = startPos.diff start.diff new Point(e.pageX, e.pageY)
      current = diff.x.clamp(0,@offsetWidth)
      percent = (current / @offsetWidth)
      @_setValue percent

    up = (e)=>
      document.removeEventListener UI.Events.dragMove, move
      document.removeEventListener UI.Events.dragEnd, up

    @addEventListener UI.Events.action, (e)->
      return if e.target is @knob.children[0]
      left = if e.touches then e.touches[0].layerX else e.layerX
      percent = left / @offsetWidth
      @_setValue percent

    @knob.children[0].addEventListener UI.Events.dragStart, (e)=>
      rect = @getBoundingClientRect()
      knobRect = @knob.getBoundingClientRect()

      start = getPosition(e)
      startPos = new Point Math.abs(rect.left-knobRect.left), Math.abs(rect.top-knobRect.top)

      document.addEventListener UI.Events.dragMove, move
      document.addEventListener UI.Events.dragEnd, up