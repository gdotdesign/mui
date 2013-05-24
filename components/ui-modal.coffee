#= require ../core/abstract

class UI.Modal extends UI.Abstract
  @TAGNAME: 'modal'

  initialize: ->
    Object.defineProperty @, 'isOpen',
      get: -> @hasAttribute('open')
    document.body.appendChild(@)

  close: ->
    return if @disabled
    @removeAttribute('open')
  open: ->
    return if @disabled
    @setAttribute('open',true)
  toggle: ->
    return if @disabled
    @toggleAttribute('open')
