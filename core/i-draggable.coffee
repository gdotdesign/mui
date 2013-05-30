class Drag
  constructor: (@base = document.body) ->

    @startPosition = null
    @mouseIsDown = false
    @position = null

    @base.addEventListener UI.Events.dragStart, @start

  getPosition: (e)->
    if e.touches
      new Point e.touches[0].pageX, e.touches[0].pageY
    else
      new Point e.pageX, e.pageY

  start: (e)=>
    return if @base.hasAttribute('disabled')

    @position = @startPosition = @getPosition(e)

    e = UI.Abstract::fireEvent.call @base, 'dragstart', {_target: e.target}
    return if e.stopped

    @mouseIsDown = true

    document.addEventListener UI.Events.dragMove, @pos
    document.addEventListener UI.Events.dragEnd, @up


    requestAnimationFrame @move

  move: =>
    requestAnimationFrame @move if @mouseIsDown
    return unless @position
    @diff = @startPosition.diff @position
    UI.Abstract::fireEvent.call @base, 'dragmove'

  pos: (e)=>
    e.preventDefault()
    @position = @getPosition(e)

  up: (e)=>
    @mouseIsDown = false
    @position = null
    document.removeEventListener UI.Events.dragMove, @pos
    document.removeEventListener UI.Events.dragEnd, @up
    UI.Abstract::fireEvent.call @base, 'dragend'
