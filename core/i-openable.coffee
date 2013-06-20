#= require abstract

# Openable Interface
class UI.iOpenable extends UI.Abstract

  # @property [Boolean] Wheter the component is open or not
  @get 'isOpen', -> @hasAttribute('open')

  # @property [String] The direction in which the component opens
  @get 'direction', ->
    dir = @getAttribute('direction')
    if @_directions.indexOf(dir) is -1 then 'bottom' else dir
  @set 'direction', (value)->
    value = 'bottom' if @_directions.indexOf(value) is -1
    if value is 'bottom' then @removeAttribute('direction') else @setAttribute('direction',value)

  # Runs when the element is inserted into the DOM
  # @private
  onAdded: ->
    # Ensure the the parent element inst `static`
    if getComputedStyle(@parentNode).position is 'static'
      @parentNode.style.position = 'relative'

  # Opens the component
  open:   -> @setAttribute('open',true)
  # Closes the component
  close:  -> @removeAttribute('open')
  # Toggles the component
  toggle: -> @toggleAttribute('open')

  # Initializes the component
  # @param [Array] @_direction The directions that the component can open
  # @private
  initialize: (@_directions = [])->