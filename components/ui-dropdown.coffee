#= require ../core/i-openable

# Dropdown component
#
# Handles the following:
#
# * Click to toggle the dropdown
# * Clicking anywhere else will close the dropdown
class UI.Dropdown extends UI.iOpenable
  # The tagname of the component
  @TAGNAME: 'dropdown'

  # Action event handler
  # @private
  _toggle: ->
    return if @parentNode.hasAttribute('disabled') or @disabled
    @toggle()

  # Action event handler
  # @private
  _open: (e)->
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

    @$open ?= @_open.bind(@)
    @$toggle ?= @_toggle.bind(@)

    if @_parent
      @_parent.removeEventListener UI.Events.action, @$open
      @_parent.removeEventListener UI.Events.action, @$toggle

    @_parent = @parentNode
    if @_parent.tagName.toLowerCase() is UI.Select.SELECTOR()
      @_parent.addEventListener UI.Events.action, @$open
    else
      @_parent.addEventListener UI.Events.action, @$toggle

  # Initializes the component
  # @private
  initialize: ->
    super ['top','bottom','left','right']
    document.addEventListener UI.Events.action, @_close.bind(@)