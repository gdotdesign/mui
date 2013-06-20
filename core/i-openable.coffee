#= require abstract

class UI.iOpenable extends UI.Abstract
  @get 'isOpen', -> @hasAttribute('open')

  @get 'direction', ->
    dir = @getAttribute('direction')
    dir = 'bottom' if @_directions.indexOf(dir) is -1
    dir
  @set 'direction', (value)->
    value = 'bottom' if @_directions.indexOf(value) is -1
    if value is 'bottom'
      @removeAttribute('direction')
    else
      @setAttribute('direction',value)

  onAdded: ->
    if getComputedStyle(@parentNode).position is 'static'
      @parentNode.style.position = 'relative'

  open:   -> @setAttribute('open',true)
  close:  -> @removeAttribute('open')
  toggle: -> @toggleAttribute('open')

  initialize: (@_directions = [])->