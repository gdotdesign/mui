#= require ../core/abstract

class UI.Button extends UI.Abstract
  @TAGNAME: 'button'

  @get 'label', -> @textContent
  @set 'label', (value) -> @textContent = value

  @get 'type', ->  @getAttribute('type') or 'default'
  @set 'type', (value) -> @setAttribute 'type', value

  _cancel: (e)->
    return unless @disabled
    e.stopImmediatePropagation()
    e.stopPropagation()

  initialize: ->
    @addEventListener UI.Events.action, @_cancel