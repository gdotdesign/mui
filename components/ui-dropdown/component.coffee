class UI.Dropdown extends UI.Abstract
  @TAGNAME: 'dropdown'

  open:   -> @setAttribute('open',true)
  close:  -> @removeAttribute('open')
  toggle: -> @toggleAttribute('open')

  onAdded: ->
    @parentNode.addEventListener 'click', =>
      return if @disabled
      return if @parentNode.hasAttribute('disabled')
      @toggle()

    if getComputedStyle(@parentNode).position is 'static'
      @parentNode.style.position = 'relative'

  initialize: ->
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