# Checkable Interface
#
# Fires `change` event.
# @abstract
class UI.iCheckable extends UI.Abstract

  # @property [Boolean] Returns the value of the component
  @get 'value', -> @hasAttribute 'checked'

  # @property [Boolean] Returns true if the component is checked otherwise false
  @get 'checked', -> @hasAttribute 'checked'
  @set 'checked', (value)->
    return if @checked is value
    @toggleAttribute 'checked', !!value
    @fireEvent 'change'

  # Toggles the component checked state unless disabled
  # @return [Boolean] The new state
  toggle: ->
    return if @disabled
    @checked = !@checked

  # Initializes the component
  # @private
  initialize: -> @addEventListener UI.Events.action, @toggle