#= require ../core/abstract

class UI.Modal extends UI.Abstract
  @TAGNAME: 'modal'

  @get 'isOpen', -> @hasAttribute 'open'

  initialize: -> document.body.appendChild(@)

  close: ->
    return if @disabled
    @removeAttribute 'open'

  open: ->
    return if @disabled
    @setAttribute 'open', true

  toggle: ->
    return if @disabled
    @toggleAttribute 'open'
