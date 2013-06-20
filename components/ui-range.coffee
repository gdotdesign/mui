#= require ../core/abstract
#= require ../core/i-draggable

class UI.Range extends UI.Abstract
  @TAGNAME: 'range'

  _setValue: (percent, set = true)->
    range = Math.abs(@min-@max)
    if set
      @value = range*percent+@min

  initialize: ->
    if @children.length is 0
      knob = document.createElement('div')
      knob.appendChild document.createElement('div')
      @appendChild knob


    @knob = @children[0]
    @knob.style.left = 0


    Object.defineProperty @, '_percent',
      get: -> Math.abs(@min-@value) / Math.abs(@min-@max)

    Object.defineProperty @, 'min',
      get: -> parseFloat @getAttribute('min')
      set: (value)->
        percent = @_percent
        @setAttribute 'min', parseFloat(value)
        @_setValue percent

    Object.defineProperty @, 'max',
      get: -> parseFloat @getAttribute('max')
      set: (value)->
        percent = @_percent
        @setAttribute 'max', parseFloat(value)
        @_setValue percent

    Object.defineProperty @, 'value',
      set: (value)->
        value = parseFloat(value)
        return if @value is value
        value = value.clamp(@min,@max)
        range = Math.abs(@min-@max)
        percent = (Math.abs(@min-value)/range)*100
        @knob.style.left = percent+"%"
        @_setValue percent/100, false
        @fireEvent 'change'
        @value
      get: ->
        percent = parseFloat @knob.style.left
        range = Math.abs(@min-@max)
        range*(percent/100)+@min

    @setAttribute 'min', 0 unless @min
    @setAttribute 'max', 100 unless @max

    if !isNaN(value = parseFloat(@getAttribute('value')))
      value = value.clamp @min, @max
      range =  Math.abs(@min-@max)
      @_setValue (value-@min)/range

    @drag = new Drag @
    @addEventListener 'dragstart', (e)=>

      e.stopPropagation()
      rect = @getBoundingClientRect()
      knobRect = @knob.getBoundingClientRect()

      @startPosition = @drag.startPosition.diff new Point(rect.left,rect.top)
      percent = @startPosition.x / @offsetWidth
      @_setValue percent

    @addEventListener 'dragmove', (e)=>
      e.stopPropagation()
      diff = @startPosition.diff @drag.diff
      current = diff.x.clamp(0,@offsetWidth)
      percent = (current / @offsetWidth)
      @_setValue percent