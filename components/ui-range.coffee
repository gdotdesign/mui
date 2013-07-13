#= require ../core/abstract
#= require ../core/drag

# Range component
class UI.Range extends UI.Abstract
  # The tagname of the component
  @TAGNAME: 'range'
  # Whether the component can receive focus
  @TABABLE: true

  # @property [Number] The range of the component
  @get 'range', -> Math.abs(@min-@max)

  # @property [Number] The current value in relation to range in percantage
  # @private
  @get '_percent', -> Math.abs(@min-@value) / @range

  # @property [Number] The minium value of the component
  @get 'min', -> parseFloat @getAttribute('min')
  @set 'min', (value)->
    percent = @_percent
    @setAttribute 'min', parseFloat(value)
    @_setValue percent

  # @property [Number] The maximum value of the component
  @get 'max', -> parseFloat @getAttribute('max')
  @set 'max', (value)->
    percent = @_percent
    @setAttribute 'max', parseFloat(value)
    @_setValue percent

  # @property [Number] The value of the component
  @get 'value', ->
    percent = parseFloat @knob.style.left
    @range*(percent/100)+@min
  @set 'value', (value)->
    value = parseFloat(value).clamp(@min,@max)
    return if @value is value
    percent = (Math.abs(@min-value)/@range)*100
    @knob.style.left = percent+"%"
    @_setValue percent/100, false
    @fireEvent 'change'
    @value

  # Sets the value via percent
  # @private
  _setValue: (percent, set = true)->
    return unless set
    @value = @range*percent+@min

  # Start event handler
  # @param [Event] e DragStart event
  # @private
  _start: (e)->
    @focus()
    e.stopPropagation()
    rect = @getBoundingClientRect()
    knobRect = @knob.getBoundingClientRect()
    @startPosition = @drag.startPosition.diff new Point(rect.left,rect.top)
    percent = @startPosition.x / @offsetWidth
    @_setValue percent

  # Move event handler
  # @param [Event] e DragMove event
  # @private
  _move: (e)->
    e.stopPropagation()
    diff = @startPosition.diff @drag.diff
    current = diff.x.clamp(0,@offsetWidth)
    percent = (current / @offsetWidth)
    @_setValue percent

  # Keydown event handler
  # @param [Event] e
  # @private
  _keydown: (e)->
    percent = @range*(if e.shiftKey then 0.1 else 0.01)
    switch e.keyCode
      when 37 # LEFT
        @value -= percent
      when 39 # RIGHT
        @value += percent

  # Initializes the component
  # @private
  initialize: ->
    if @children.length is 0
      knob = document.createElement('div')
      knob.appendChild document.createElement('div')
      @appendChild knob

    @knob = @children[0]
    @knob.style.left = 0

    @setAttribute 'min', 0 unless @min
    @setAttribute 'max', 100 unless @max

    if !isNaN(value = parseFloat(@getAttribute('value')))
      value = value.clamp @min, @max
      @_setValue (value-@min)/@range

    @drag = new Drag @

    @addEventListener 'dragstart', @_start
    @addEventListener 'dragmove', @_move
    @addEventListener 'keydown', @_keydown
