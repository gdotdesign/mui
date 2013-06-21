#= require ../core/abstract

# Modal Component
class UI.Modal extends UI.Abstract
  @TAGNAME: 'modal'

  # @property [Boolean] Returns true if the component is open false otherwise
  @get 'isOpen', -> @hasAttribute 'open'

  # Closes the component
  close: ->
    return if @disabled
    @removeAttribute 'open'

  # Opens the component
  open: ->
    return if @disabled
    @setAttribute 'open', true

  # Toggles the component
  toggle: ->
    return if @disabled
    @toggleAttribute 'open'

  # Initializes the component
  # @private
  initialize: -> document.body.appendChild(@)
