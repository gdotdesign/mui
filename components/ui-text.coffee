#= require ../core/i-input

class UI.Text extends UI.iInput
  @TAGNAME: 'text'
  initialize: ->
    super
    @addEventListener 'keydown', (e) ->
      e.preventDefault() if e.keyCode is 13