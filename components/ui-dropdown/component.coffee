class UI.Dropdown extends UI.Abstract
  @TAGNAME: 'dropdown'

  open: -> @setAttribute('open',true)
  close: -> @removeAttribute('open')

  onAdded: ->
    @parentNode.addEventListener 'click', @toggle
    # Ensure parent node is "relative"
    if getComputedStyle(@parentNode).position is 'static'
      @parentNode.style.position = 'relative'

  toggle: ->
    return if @parentNode.hasAttribute('disabled')
    # Hack something do with scope
    @_open = !@_open
    if @_open then @open() else @close()

  initialize: ->
    @_open = false
    document.addEventListener 'click', (e)=>
      # TODO child checking
      @close() if e.target isnt @
    , true