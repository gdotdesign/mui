#= require ../core/abstract

class UI.Checkbox extends UI.Abstract
  @TAGNAME: 'checkbox'

  initialize: ->
    Object.defineProperty @, 'checked',
      get: -> @hasAttribute 'checked'
      set: (value)->
        checked = @checked
        @toggleAttribute 'checked', !!value
        if checked isnt !!value
          @fireEvent 'change'

    @addEventListener 'click', =>
      return if @disabled
      @checked = !@checked
