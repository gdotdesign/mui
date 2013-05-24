class UI.iInput extends UI.Abstract
  @TAGNAME: 'input'
  @wrap: (el)->
    super
    Object.defineProperty el, 'value',
      get: ->  @textContent
      set: (value)-> @textContent = value

  initialize: ->
    @setAttribute('contenteditable',true)
    @_input = document.createElement('input')
    @addEventListener 'blur', (e) ->
      if @childNodes.length is 1
        if @childNodes[0].tagName is 'BR'
          @removeChild @childNodes[0]