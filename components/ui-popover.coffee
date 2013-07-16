#= require ../core/i-openable

# Dropdown component
class UI.Popover extends UI.iOpenable
  # The tagname of the component
  @TAGNAME: 'popover'

  # Action event handler
  # @private
  _toggle: ->
    return if @parentNode.hasAttribute('disabled') or @disabled
    @toggle()

  # Action event handler
  # @private
  _open: ->
    return if @parentNode.hasAttribute('disabled') or @disabled
    @open()

  # Action event handler for document
  # @private
  _close: (e)->
    return if @parentNode.hasAttribute('disabled') or @disabled
    @close() if getParent(e.target, UI.Dropdown.SELECTOR()) isnt @ and getParent(e.target,@parentNode.tagName) isnt @parentNode

  # Runs when the element is inserted into the DOM
  # @private
  onAdded: ->
    super
    @parentNode.addEventListener UI.Events.action, @_toggle.bind(@)

  # Initializes the component
  # @private
  initialize: ->
    super ['top','bottom','left','right']
    document.addEventListener UI.Events.action, @_close.bind(@)