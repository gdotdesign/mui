#= require ../core/i-openable

# Tooltip Component
class UI.Tooltip extends UI.iOpenable
  # The tagname of the component
  @TAGNAME: 'tooltip'

  # Enter event hanlder
  # @private
  _enter: (e)->
    return if @parentNode.hasAttribute('disabled') or @disabled
    return if getParent(e.target, UI.Tooltip.SELECTOR())
    @setAttribute('open',true)

  # Leave event hanlder
  # @private
  _leave: ->
    return if @parentNode.hasAttribute('disabled') or @disabled
    @removeAttribute('open')

  # Runs when the element is inserted into the DOM
  # @private
  onAdded: ->
    super
    @parentNode.addEventListener UI.Events.enter, @_enter.bind(@)
    @parentNode.addEventListener UI.Events.leave, @_leave.bind(@)

  # Initializes the component
  # @private
  initialize: -> super ['top','bottom','left','right']