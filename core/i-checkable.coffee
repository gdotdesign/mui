# Checkable Interface
#
# Fires `change` event.
# @abstract
class UI.iCheckable extends UI.Abstract
  @TABABLE: true
  
  # @property [Boolean] Returns the value of the component
  @get 'value', -> @hasAttribute 'checked'
  @set 'value', (value) -> @checked = value

  # @property [Boolean] Returns true if the component is checked otherwise false
  @get 'checked', -> @hasAttribute 'checked'
  @set 'checked', (value)->
    return if @checked is value
    @toggleAttribute 'checked', !!value
    @fireEvent 'change'

  # Action event handler
  # @private
  _toggle: ->
    return if @parentNode.hasAttribute('disabled') or @disabled
    @toggle()

  # Toggles the component checked state unless disabled
  # @return [Boolean] The new state
  toggle: -> @checked = !@checked

  # Initializes the component
  # @private
  initialize: ->
    @addEventListener UI.Events.action, @_toggle
    @addEventListener 'keydown', (e)-> @_toggle() if e.keyCode is 13