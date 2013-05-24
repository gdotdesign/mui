#= require ../core/abstract

class UI.Button extends UI.Abstract
  @TAGNAME: 'button'

  _cancel: (e)->
    return unless @disabled
    e.stopImmediatePropagation()
    e.stopPropagation()

  initialize: ->
    @addEventListener UI.Events.action, @_cancel

    Object.defineProperty @, 'label',
      get:        -> @textContent
      set: (value)-> @textContent = value

    Object.defineProperty @, 'type',
      get:        -> @getAttribute('type') or 'default'
      set: (value)-> @setAttribute 'type', value