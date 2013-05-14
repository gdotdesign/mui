class UI.Modal extends UI.Abstract
  @TAGNAME: 'modal'
  initialize: ->
    document.body.appendChild(@)
  toggle: ->
    @toggleAttribute('open')
