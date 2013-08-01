# The main object of the MUI
#
# @mixin
UI =
  verbose: false
  namespace: 'ui'
  version: '0.1.0-RC1'

  validators:
    required:
      condition: -> @required
      validate: -> !!@value
      message: 'This field is required!'
    maxlength:
      condition: -> @maxlength isnt Infinity
      validate: -> @maxlength >= @value.toString().length
      message: -> 'Length cannot be bigger then '+@maxlength+"!"
    pattern:
      condition: ->
        return false unless @pattern
        @pattern.toString() isnt "/^.*$/"
      validate: ->
        return false unless @pattern
        @pattern.test @value.toString()
      message: 'Value must match the provided pattern!'
    email:
      condition: -> @required
      validate: -> /^[a-z0-9!#$%&'"*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])$/.test @value.toString()
      message: 'Must be an email address!'

  # Wraps password fields with methods
  _wrapPassword: (el)->
    return if el._processed
    el.validators ?= UI.Text::validators
    for key, desc of UI._geather UI.iValidable::
      continue if key is 'initialize' or key is 'constructor'
      originDesc = Object.getOwnPropertyDescriptor(el,key)
      continue if originDesc and not originDesc.configurable
      Object.defineProperty el, key, desc
    UI.iValidable::initialize.call el
    el._processed = true

  # Loads components (first initialization)
  load: (base = document)->
    for el in base.querySelectorAll('input[type=password]')
      return if el._processed
      @_wrapPassword el
    for key, value of UI
      if value.SELECTOR
        for el in base.querySelectorAll(value.SELECTOR())
          continue if el._processed
          @load(el)
          value.wrap el
          el.onAdded?()

  # Initailizeses components (current and in the future)
  initialize: ->
    document.addEventListener 'DOMNodeInserted', @_insert.bind(@), true
    window.addEventListener 'load', =>
      UI.onBeforeLoad?()
      @load()
      setTimeout ->
        document.body.setAttribute 'loaded', true
        UI.onLoad?()
      , 1000

  # Promises simple element
  # @param [String] tag
  # @param [Object] attributes
  # @param [Array] attributer
  # @return [Function]
  promiseElement: (tag, attributes = {}, children = [])->
    (parent)->
      throw "Illegal tagname" unless typeof tag is 'string'
      throw "Illegal attributes" unless typeof attributes is 'object'
      el = document.createElement(tag)
      for key, value of attributes
        el.setAttribute key, value
      if children
        throw "Illegal children" unless children instanceof Array
        UI._build.call el, children, parent
      el

  # Builds elements
  # @param [Array] children
  # @param [Element] parent
  _build: (children,parent)->
    return unless children
    for promise in children
      if typeof promise is 'string'
        node = document.createTextNode(promise)
        @appendChild node
      else if promise instanceof Function
        @appendChild promise(parent)
      else
        for key, prom of promise
          el = prom(parent)
          @appendChild el
          parent[key] = el

  # Runs when a node is inserted into the document
  # @private
  _insert: (e)->
    return unless e.target.tagName
    tagName = e.target.tagName
    if tagName is 'INPUT' and e.target.getAttribute('type') is 'password'
      @_wrapPassword e.target
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
      if key is 'implements'
        for object in obj[key]
          for k, d of @_geather(object::)
            ret[k] ?= d
      else
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
