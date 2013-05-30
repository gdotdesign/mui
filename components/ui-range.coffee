#= require ../core/abstract

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

    startPos = start = null
    mouseIsDown = false

    getPosition = (e)->
      if e.touches
        new Point e.touches[0].pageX, e.touches[0].pageY
      else
        new Point e.pageX, e.pageY

    move = (e)=>
      diff = startPos.diff start.diff new Point(@pageX, @pageY)
      current = diff.x.clamp(0,@offsetWidth)
      percent = (current / @offsetWidth)
      @_setValue percent
      requestAnimationFrame move if mouseIsDown

    pos = (e)=>
      e.preventDefault()
      @pageX = e.pageX
      @pageY = e.pageY

    up = (e)=>
      mouseIsDown = false
      document.removeEventListener UI.Events.dragMove, pos
      document.removeEventListener UI.Events.dragEnd, up

    @addEventListener UI.Events.dragStart, (e)=>
      return if @disabled

      rect = @getBoundingClientRect()
      knobRect = @knob.getBoundingClientRect()

      start = getPosition(e)
      startPos = start.diff new Point(rect.left,rect.top)

      percent = startPos.x / @offsetWidth
      @_setValue percent
      mouseIsDown = true

      document.addEventListener UI.Events.dragMove, pos
      requestAnimationFrame move
      document.addEventListener UI.Events.dragEnd, up