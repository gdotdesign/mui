Test.add 'Drag',->
  drag = new Drag()
  @case 'Default base should be body', ->
    @assert drag.base is document.body

  @case 'Reset should be called on constructor', ->
    @assert drag.position is null
    @assert drag.startPosition is null
    @assert drag.mouseIsDown is false

  @case 'Reset should reset position, startPosition, and mouseIsDown', ->
    drag.position = 1
    drag.startPosition = 2
    drag.mouseIsDown = 3
    drag.reset()
    @assert drag.position is null
    @assert drag.startPosition is null
    @assert drag.mouseIsDown is false

  @case 'Diff should return null if no startPosition or position', ->
    @assert drag.diff is null

  @case 'Start should fire dragstart event', ->
    x = false
    fn = -> x = true
    document.body.addEventListener 'dragstart', fn
    UI.Abstract::fireEvent.call document.body, UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert x
    UI.Abstract::fireEvent.call document.body, UI.Events.dragEnd
    document.body.removeEventListener 'dragstart', fn

  @case 'Start should not fire dragstart event is base is disabled', ->
    x = false
    fn = -> x = true
    document.body.addEventListener 'dragstart', fn
    document.body.setAttribute 'disabled', true
    UI.Abstract::fireEvent.call document.body, UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert !x
    document.body.removeAttribute 'disabled'
    UI.Abstract::fireEvent.call document.body, UI.Events.dragEnd
    document.body.removeEventListener 'dragstart', fn

  @case 'Start should set mouseIsDown', ->
    UI.Abstract::fireEvent.call document.body, UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert drag.mouseIsDown
    UI.Abstract::fireEvent.call document.body, UI.Events.dragEnd

  @case 'Start should not set mouseIsDown if the event is stopped', ->
    fn = (e)-> e.stopped = true
    document.body.addEventListener 'dragstart', fn
    UI.Abstract::fireEvent.call document.body, UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert !drag.mouseIsDown
    document.body.removeEventListener 'dragstart', fn

  @case 'Diff should return point', ->
    UI.Abstract::fireEvent.call document.body, UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert drag.diff instanceof Point
    UI.Abstract::fireEvent.call document.body, UI.Events.dragEnd

  @case 'Diff should return relative displacement', ->
    UI.Abstract::fireEvent.call document.body, UI.Events.dragStart, {pageX: 0, pageY: 0}
    UI.Abstract::fireEvent.call document.body, UI.Events.dragMove, {touches: [{pageX: 10, pageY: 10}]}
    @assert drag.diff.x is -10
    @assert drag.diff.x is -10
    UI.Abstract::fireEvent.call document.body, UI.Events.dragEnd

  @case 'Up should fire dragEnd event', ->
    UI.Abstract::fireEvent.call document.body, UI.Events.dragStart, {pageX: 0, pageY: 0}
    x = false
    fn = (e)-> x = true
    document.body.addEventListener 'dragend', fn
    UI.Abstract::fireEvent.call document.body, UI.Events.dragEnd
    @assert x

  @case 'Up should call reset', ->
    UI.Abstract::fireEvent.call document.body, UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert drag.position isnt null
    @assert drag.startPosition isnt null
    @assert drag.mouseIsDown
    UI.Abstract::fireEvent.call document.body, UI.Events.dragEnd
    @assert drag.position is null
    @assert drag.startPosition is null
    @assert drag.mouseIsDown is false