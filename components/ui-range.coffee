#= require ../core/abstract

class Point
  constructor: (@x,@y)->
  diff: (point)->
    new Point @x-point.x, @y-point.y

Number::clamp = (min,max)->
  if @valueOf() < min then min else if @valueOf() > max then max else @valueOf()

class UI.Range extends UI.Abstract
  @TAGNAME: 'range'

  initialize: ->
    @knob = @children[0]
    @knob.style.left = 0

    Object.defineProperty @, 'min',
      get: -> parseFloat @getAttribute('min')
      set: (value)->
        oldRange = Math.abs(@min-@max)
        percent = Math.abs(@min-@value)/oldRange
        @setAttribute 'min', parseFloat(value)
        newRange = Math.abs(@min-@max)
        @value = newRange*percent+@min

    Object.defineProperty @, 'max',
      get: -> parseFloat @getAttribute('max')
      set: (value)->
        oldRange = Math.abs(@min-@max)
        percent = Math.abs(@min-@value)/oldRange
        @setAttribute 'max', parseFloat(value)
        newRange = Math.abs(@min-@max)
        @value = newRange*percent+@min

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

    move = (e)=>
      diff = startPos.diff start.diff new Point(e.pageX, e.pageY)
      current = diff.x.clamp(0,@offsetWidth)
      percent = (current / @offsetWidth)
      range = Math.abs(@min-@max)
      @value = range*percent+@min

    up = (e)=>
      document.removeEventListener 'mousemove', move
      document.removeEventListener 'mouseup', up

    @addEventListener 'click', (e)->
      return if e.target is @knob
      percent = (e.layerX / @offsetWidth)
      range = Math.abs(@min-@max)
      @value = range*percent+@min

    @knob.addEventListener 'mousedown', (e)=>
      rect = @getBoundingClientRect()
      knobRect = @knob.getBoundingClientRect()

      start = new Point e.pageX, e.pageY
      startPos = new Point Math.abs(rect.left-knobRect.left), Math.abs(rect.top-knobRect.top)

      document.addEventListener 'mousemove', move
      document.addEventListener 'mouseup', up

