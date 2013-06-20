# Class for drag management.
#
# This class will not drag the element only compute diffs and handle pointer events.
#
# Emits `dragstart`, `dragmove`, `dragend` events on the provided element.
#
# @see https://github.com/gdotdesign/mui/blob/master/components/ui-range.coffee UI.Range
class Drag

  # @property [Point] The relative displacement of the mouse from the starting point
  @get 'diff', -> @startPosition.diff @position

  # @param [Element] @base The element in which to initalize event listeners
  constructor: (@base = document.body) ->
    @reset()
    @base.addEventListener UI.Events.dragStart, @start

  # Resets internal variables
  # @private
  reset: ->
    @position = @startPosition = null
    @mouseIsDown = false

  # Gets the current position as a point from an event
  # @param [e] Event
  # @return [Point] The point
  # @private
  getPosition: (e)->
    if e.touches
      new Point e.touches[0].pageX, e.touches[0].pageY
    else
      new Point e.pageX, e.pageY

  # Start event handler
  # @param [e] Event
  # @private
  start: (e)=>
    return if @base.hasAttribute('disabled')

    @position = @startPosition = @getPosition(e)

    event = UI.Abstract::fireEvent.call @base, 'dragstart', {_target: e.target, shiftKey: e.shiftKey}
    return if event.stopped

    @mouseIsDown = true

    document.addEventListener UI.Events.dragMove, @pos
    document.addEventListener UI.Events.dragEnd, @up

    requestAnimationFrame @move

  # Move event handler
  # @private
  move: =>
    requestAnimationFrame @move if @mouseIsDown
    return unless @position
    UI.Abstract::fireEvent.call @base, 'dragmove'

  # Sets curent position from event
  # @param [e] Event
  # @return [Point] The Position
  pos: (e)=>
    e.preventDefault()
    @position = @getPosition(e)

  # Complete event handler
  # @private
  up: (e)=>
    @reset()
    document.removeEventListener UI.Events.dragMove, @pos
    document.removeEventListener UI.Events.dragEnd, @up
    UI.Abstract::fireEvent.call @base, 'dragend'
