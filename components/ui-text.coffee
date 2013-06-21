#= require ../core/i-input

# Text Input Compontent
class UI.Text extends UI.iInput
  @TAGNAME: 'text'

  # BeforeInput event handler
  # @private
  _keydown: (e) ->
    e.preventDefault() if e.keyCode is 13

  # Initializes the component
  # @private
  initialize: ->
    super
    @addEventListener UI.Events.beforeInput, @_keydown