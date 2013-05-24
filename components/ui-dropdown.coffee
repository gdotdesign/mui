#= require ../core/i-openable

class UI.Dropdown extends UI.iOpenable
  @TAGNAME: 'dropdown'

  _cancel: ->
    return if @parentNode.hasAttribute('disabled') or @disabled
    @toggle()

  _close: (e)->
      @close() if e.target isnt @ and e.target isnt @parentNode

  onAdded: ->
    super
    @parentNode.addEventListener UI.Events.action, @_cancel.bind(@)

  initialize: ->
    super ['top','bottom']

    document.addEventListener UI.Events.action, @_close, true