class UI.Dropdown extends UI.Abstract
  @TAGNAME: 'dropdown'

  onAdded: ->
    if @parentNode
      @parentNode.addEventListener 'click', @toggle
      if @parentNode.style.position is ''
        @parentNode.style.position = 'relative'

  toggle: ->
    return if @parentNode.hasAttribute('disabled')
    @_open = !@_open
    if @_open
      @removeAttribute('open')
    else
      @setAttribute('open',true)

  initialize: ->
    @_open = true
    document.addEventListener 'click', (e)=>
      if e.target isnt @
        @removeAttribute('open')
    , true