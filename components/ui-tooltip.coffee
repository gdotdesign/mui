7#= require ../core/i-openable

# Tooltip Component
class UI.Tooltip extends UI.iOpenable
  # The tagname of the component
  @TAGNAME: 'tooltip'

  # @property [Object] The label of the component
  @get 'label', -> @textContent
  @set 'label', (value)-> @textContent = value

  # Enter event hanlder
  # @private
  _enter: (e)->
    return if @parentNode.hasAttribute('disabled') or @disabled
    return if getParent(e.target, UI.Tooltip.SELECTOR())
    @open()

  # Leave event hanlder
  # @private
  _leave: ->
    return if @parentNode.hasAttribute('disabled') or @disabled
    @close()

  # Keydown event hanlder
  # @private
  _toggle: ->
    return if @parentNode.hasAttribute('disabled') or @disabled
    @toggle()

  # Runs when the element is inserted into the DOM
  # @private
  onAdded: ->
    super
    @parentNode.addEventListener UI.Events.enter, @_enter.bind(@)
    @parentNode.addEventListener UI.Events.leave, @_leave.bind(@)
    @parentNode.addEventListener 'keydown', (e)=>
      @_toggle() if e.altKey

  # Initializes the component
  # @private
  initialize: ->
    super ['top','bottom','left','right']