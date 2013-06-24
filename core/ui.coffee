# The main object of the MUI
#
# @mixin
UI =
  verbose: false
  namespace: 'ui'
  # Loads components (first initialization)
  load: (base = document)->
    for key, value of UI
      if value.SELECTOR
        for el in base.querySelectorAll(value.SELECTOR())
          continue if el._processed
          @load(el)
          value.wrap el

  # Initailizeses components (current and in the future)
  initialize: ->
    document.addEventListener 'DOMNodeInserted', @_insert.bind @
    window.addEventListener 'load', => @load()

  # Runs when a node is inserted into the document
  # @private
  _insert: (e)->
    return unless e.target.tagName
    tagName = e.target.tagName
    return unless tagName.match /^UI-/
    tag = tagName.split("-").pop().toLowerCase().replace /^\w|\s\w/g, (match) ->  match.toUpperCase()
    return unless @[tag]
    unless e.target._processed
      @[tag].wrap e.target
    else
      e.target.onAdded?()

  # Create an object representing a Classes properties from the prototype chain.
  # @private
  _geather: (obj)->
    ret = {}
    for key in Object.keys(obj)
      ret[key] = Object.getOwnPropertyDescriptor(obj,key)
    if (proto = Object.getPrototypeOf(obj)) isnt Object::
      for key, desc of @_geather(proto)
        ret[key] ?= desc
    ret

window.UI = UI

# TODO: Refactor
# TODO: IE10 pointerEvents support
if !!('ontouchstart' of window)
  UI.Events =
    action: 'touchend'
    dragStart: 'touchstart'
    dragMove: 'touchmove'
    dragEnd: 'touchend'
    enter: 'touchstart'
    leave: 'touchend'
    input: 'input'
    beforeInput: 'keydown'
    blur: 'blur'
    keypress: 'keypress'
    keyup: 'keyup'
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
    blur: 'blur'
    keypress: 'keypress'
    keyup: 'keyup'
