class UI.Dropdown extends UI.Abstract
  @TAGNAME: 'dropdown'

  open: -> @setAttribute('open',true)
  close: -> @removeAttribute('open')

  onAdded: ->
    @parentNode.addEventListener 'click', @toggle
    if getComputedStyle(@parentNode).position is 'static'
      @parentNode.style.position = 'relative'

  toggle: ->
    return if @parentNode.hasAttribute('disabled')
    @toggleAttribute('open')

  initialize: ->
    @_open = false
    directions = ['top','bottom']
    Object.defineProperty @, 'isOpen',
      get: -> @hasAttribute('open')
    Object.defineProperty @, 'direction',
      get: ->
        dir = @getAttribute('direction')
        dir = 'bottom' if directions.indexOf(dir) is -1
        dir
      set: (value)->
        value = 'bottom' if directions.indexOf(value) is -1
        if value is 'bottom'
          @removeAttribute('direction')
        else
          @setAttribute('direction',value)

    document.addEventListener 'click', (e)=>
      @close() if e.target isnt @ and e.target isnt @parentNode
    , true