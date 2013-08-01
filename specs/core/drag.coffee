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
    document.body.fireEvent UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert x
    document.body.fireEvent UI.Events.dragEnd
    document.body.removeEventListener 'dragstart', fn

  @case 'Start should not fire dragstart event is base is disabled', ->
    x = false
    fn = -> x = true
    document.body.addEventListener 'dragstart', fn
    document.body.setAttribute 'disabled', true
    document.body.fireEvent UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert !x
    document.body.removeAttribute 'disabled'
    document.body.fireEvent UI.Events.dragEnd
    document.body.removeEventListener 'dragstart', fn

  @case 'Start should set mouseIsDown', ->
    document.body.fireEvent UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert drag.mouseIsDown
    document.body.fireEvent UI.Events.dragEnd

  @case 'Start should not set mouseIsDown if the event is stopped', ->
    fn = (e)-> e.stopped = true
    document.body.addEventListener 'dragstart', fn
    document.body.fireEvent UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert !drag.mouseIsDown
    document.body.removeEventListener 'dragstart', fn

  @case 'Diff should return point', ->
    document.body.fireEvent UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert drag.diff instanceof Point
    document.body.fireEvent UI.Events.dragEnd

  @case 'Diff should return relative displacement', ->
    document.body.fireEvent UI.Events.dragStart, {pageX: 0, pageY: 0}
    document.body.fireEvent UI.Events.dragMove, {touches: [{pageX: 10, pageY: 10}]}
    @assert drag.diff.x is -10
    @assert drag.diff.x is -10
    document.body.fireEvent UI.Events.dragEnd

  @case 'Up should fire dragEnd event', ->
    document.body.fireEvent UI.Events.dragStart, {pageX: 0, pageY: 0}
    x = false
    fn = (e)-> x = true
    document.body.addEventListener 'dragend', fn
    document.body.fireEvent UI.Events.dragEnd
    @assert x

  @case 'Up should call reset', ->
    document.body.fireEvent UI.Events.dragStart, {pageX: 0, pageY: 0}
    @assert drag.position isnt null
    @assert drag.startPosition isnt null
    @assert drag.mouseIsDown
    document.body.fireEvent UI.Events.dragEnd
    @assert drag.position is null
    @assert drag.startPosition is null
    @assert drag.mouseIsDown is false

    drag.destroy()