class UI.Dropdown extends UI.Abstract
  @TAGNAME: 'dropdown'

  onAdded: ->
    @parentNode.addEventListener 'click', @toggle

  toggle: ->
    return if @parentNode.hasAttribute('disabled')
    @_open = !@_open
    if @_open
      @removeAttribute('open')
    else
      @setAttribute('open',true)

  initialize: ->
    @_open = true
    @onAdded() if @parentNode
    document.addEventListener 'click', (e)=>
      if e.target isnt @
        @removeAttribute('open')
    , true