#= require ../core/abstract

# Button Component
class UI.Button extends UI.Abstract
  # The tagname of the component
  @TAGNAME: 'button'
  # Whether the component can receive focus
  @TABABLE: true

  # @property [String] Alias for textContent property.
  @get 'label', -> @textContent
  @set 'label', (value) -> @textContent = value

  # @property [Type] Alias for type attrbiute. Default is `default`.
  @get 'type', ->  @getAttribute('type') or 'default'
  @set 'type', (value) ->
    return @removeAttribute('type') unless value
    @setAttribute 'type', value

  # Cancels and event if the component is disabled
  # @param [Event] e
  # @private
  _cancel: (e)->
    return unless @disabled
    e.stopImmediatePropagation()
    e.stopPropagation()

  # Keydown event handler
  # @param [Event] e
  # @private
  _keydown: (e)->
    if e.keyCode is 13
      e.preventDefault()
      @fireEvent UI.Events.action 

  # Initializes the component
  # @private
  initialize: ->
    @addEventListener UI.Events.action, @_cancel
    @addEventListener 'keydown', @_keydown