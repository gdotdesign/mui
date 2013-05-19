class UI.Modal extends UI.Abstract
  @TAGNAME: 'modal'

  initialize: ->
    Object.defineProperty @, 'isOpen',
      get: -> @hasAttribute('open')
    document.body.appendChild(@)

  close: -> @removeAttribute('open')
  open: -> @setAttribute('open',true)
  toggle: ->
    return if @disabled
    @toggleAttribute('open')
