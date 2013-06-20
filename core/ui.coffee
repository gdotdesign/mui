isTouch = !!('ontouchstart' of window)

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
  load: (base = document)->
    for key, value of UI
      if value.SELECTOR
        for el in base.querySelectorAll(value.SELECTOR())
          continue if el._processed
          UI.load(el)
          value.wrap el

  initialize: ->
    document.addEventListener 'DOMNodeInserted', UI.onInsert
    window.addEventListener 'load', ->
      window.ColorPicker = new ColorPicker
      UI.load()

  _geather: (obj)->
    ret = {}
    for key in Object.keys(obj)
      ret[key] = Object.getOwnPropertyDescriptor(obj,key)
    if (proto = Object.getPrototypeOf(obj)) isnt Object::
      for key, desc of UI._geather(proto)
        ret[key] ?= desc
    ret

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

class Point
  constructor: (@x,@y)->
  diff: (point)->
    new Point @x-point.x, @y-point.y

unless 'scrollY' of window
  Object.defineProperty window, 'scrollY', get: ->
    if document.documentElement
      document.documentElement.scrollTop

Element::getPosition = ->
  rect = getComputedStyle(@)
  new Point parseInt(rect.left), parseInt(rect.top) + window.scrollY

Number::clamp =(min,max) ->
  min = parseFloat(min)
  max = parseFloat(max)
  val = @valueOf()
  if val > max
    max
  else if val < min
    min
  else
    val

Number::clampRange = (min,max) ->
  min = parseFloat(min)
  max = parseFloat(max)
  val = @valueOf()
  if val > max
    val % max
  else if val < min
    max - Math.abs(val % max)
  else
    val
