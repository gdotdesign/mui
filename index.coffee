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


class UI.Abstract
  @SELECTOR: -> UI.ns+"-"+@TAGNAME
  @wrap: (el)->
    for key, fn of @::
      if key isnt 'initialize'
        el[key] = fn.bind(el)
    el._processed = true
    @::initialize?.call el

    Object.defineProperty el, 'disabled',
      get: -> @hasAttribute('disabled')
      set: (value) ->
        value = !!value
        if value
          @setAttribute('disabled',true)
        else
          @removeAttribute('disabled')

    el.onAdded?() if el.parentNode

  @create: ->
    base = document.createElement(@SELECTOR())
    @wrap base
    base

  fireEvent: (type,data)->
    event = document.createEvent("HTMLEvents")
    event.initEvent(type, true, true)
    for key, value of data
      event[key] = value
    @dispatchEvent(event)
    event

  toString: ->
    "<#{@tagName.toLowerCase()}>"

class UI.iOpenable extends UI.Abstract
  onAdded: ->
    if getComputedStyle(@parentNode).position is 'static'
      @parentNode.style.position = 'relative'

  open:   -> @setAttribute('open',true)
  close:  -> @removeAttribute('open')
  toggle: -> @toggleAttribute('open')

  initialize: (directions = [])->
    Object.defineProperty @, 'isOpen', get: -> @hasAttribute('open')
    Object.defineProperty @, 'direction',
      get: ->
        dir = @getAttribute('direction')
        dir = 'bottom' if directions.indexOf(dir) is -1
        dir
      set: (value)->
        value = 'bottom' if directions.indexOf(value) is -1
        if value is 'bottom'
          @removeAttribute('direction')
        else
          @setAttribute('direction',value)

class UI.iInput extends UI.Abstract
  @TAGNAME: 'input'
  @wrap: (el)->
    super
    Object.defineProperty el, 'value',
      get: ->  @textContent
      set: (value)-> @textContent = value

  initialize: ->
    @setAttribute('contenteditable',true)
    @_input = document.createElement('input')
    @addEventListener 'blur', (e) ->
      if @childNodes.length is 1
        if @childNodes[0].tagName is 'BR'
          @removeChild @childNodes[0]