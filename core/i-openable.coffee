#= require abstract

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