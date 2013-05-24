#= require ../core/i-input

class UI.Text extends UI.iInput
  @TAGNAME: 'text'

  _keydown: (e) ->
    e.preventDefault() if e.keyCode is 13

  initialize: ->
    super
    @addEventListener UI.Events.beforeInput, @_keydown