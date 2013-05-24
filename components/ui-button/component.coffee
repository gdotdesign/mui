#= require ../../core/abstract

class UI.Button extends UI.Abstract
  @TAGNAME: 'button'

  initialize: ->
    @addEventListener 'click', (e)->
      if @disabled
        e.stopImmediatePropagation()
        e.stopPropagation()

    Object.defineProperty @, 'label',
      get:        -> @textContent
      set: (value)-> @textContent = value

    Object.defineProperty @, 'type',
      get:        -> @getAttribute('type') or 'default'
      set: (value)-> @setAttribute 'type', value