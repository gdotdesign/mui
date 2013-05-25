class UI.iCheckable extends UI.Abstract
  toggle: ->
    return if @disabled
    @checked = !@checked

  initialize: ->
    @addEventListener UI.Events.action, @toggle

    Object.defineProperty @, 'value',
      get: -> @hasAttribute 'checked'
    Object.defineProperty @, 'checked',
      get: -> @hasAttribute 'checked'
      set: (value)->
        lastValue = @checked
        value = !!value
        @toggleAttribute 'checked', value
        if lastValue isnt value
          @fireEvent 'change'
