#= require ../core/abstract

class UI.Checkbox extends UI.Abstract
  @TAGNAME: 'checkbox'

  toggle: ->
    return if @disabled
    @checked = !@checked

  initialize: ->
    @addEventListener UI.Events.action, @toggle

    Object.defineProperty @, 'checked',
      get: -> @hasAttribute 'checked'
      set: (value)->
        lastValue = @checked
        value = !!value
        @toggleAttribute 'checked', value
        if lastValue isnt value
          @fireEvent 'change'
