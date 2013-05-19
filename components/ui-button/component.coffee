class UI.Button extends UI.Abstract
  @TAGNAME: 'button'

  initialize: ->
    Object.defineProperty @, 'label',
      get: ->
        @textContent
      set: (value)->
        @textContent = value

    Object.defineProperty @, 'type',
      get: ->
        @getAttribute('type') or 'default'
      set: (value)->
        @setAttribute 'type', value