#= require ui

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