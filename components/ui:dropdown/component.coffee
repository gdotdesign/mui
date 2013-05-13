class UI.Dropdown extends UI.Abstract
  @TAGNAME: 'dropdown'

  onAdded: ->
    if @parentNode
      @parentNode.addEventListener 'click', @toggle
      if getComputedStyle(@parentNode).position is 'static'
        @parentNode.style.position = 'relative'

  toggle: ->
    return if @parentNode.hasAttribute('disabled')
    @_open = !@_open
    if @_open
      @open()
    else
      @close()

  open: ->
    @setAttribute('open',true)

  close: ->
    @removeAttribute('open')

  initialize: ->
    @_open = false
    document.addEventListener 'click', (e)=>
      if e.target isnt @
        @close()
    , true