isTouch = !!('ontouchstart' of window) or !!('onmsgesturechange' of window)

UI =
  verbose: false
  ns: 'ui'
  warn: (text)->
    console.warn text
  log: (args...)->
    if UI.verbose
      console.log.apply console, args
  onInsert: (e)->
    return unless e.target.tagName
    tagName = e.target.tagName
    if tagName.match /^UI-/
      tag = tagName.split("-").pop().toLowerCase().replace /^\w|\s\w/g, (match) ->  match.toUpperCase()
      if UI[tag]
        unless e.target._processed
          UI[tag].wrap e.target
        else
          e.target.onAdded?()
  load: ->
    for key, value of UI
      if value.SELECTOR
        for el in document.querySelectorAll(value.SELECTOR())
          value.wrap el
  initialize: ->
    document.addEventListener 'DOMNodeInserted', UI.onInsert
    window.addEventListener 'load', UI.load


if isTouch
  UI.Events =
    action: 'touchend'
    dragStart: 'touchstart'
    dragMove: 'touchmove'
    dragEnd: 'touchend'
    enter: 'touchstart'
    leave: 'touchend'
    input: 'input'
    beforeInput: 'keydown'
else
  UI.Events =
    action: 'click'
    dragStart: 'mousedown'
    dragMove: 'mousemove'
    dragEnd: 'mouseup'
    enter: 'mouseover'
    leave: 'mouseout'
    input: 'input'
    beforeInput: 'keydown'