#= require ../core/abstract

# Context menu component
class UI.Context extends UI.Abstract
  # The tagname of the component
  @TAGNAME: 'context'

  # Open Event handler
  # @private
  _open: (e)->
    return if @disabled
    e.stopPropagation()
    e.stopImmediatePropagation()
    e.preventDefault()
    {pageX, pageY} = e
    @open pageX, pageY

  # Close Event handler
  # @private
  _close: (e)->
    return if e.button is 2
    return if @disabled
    @close()

  # Opens the context menu at the specified points
  # @param [Number] left The left position of the menu
  # @param [Number] top The top position of the menu
  open: (left, top)->
    if !left or !top
      {left, top} = @parentNode.getBoundingClientRect()
    @style.left = left+"px"
    @style.top = top+"px"
    @setAttribute 'open', true

  # Closes the context menu
  close: ->
    @removeAttribute 'open'

  # Runs when the element is inserted into the DOM
  # @private
  onAdded: ->
    return if @added
    @added = true
    @_parentNode = @parentNode
    @parentNode.addEventListener 'contextmenu', @$open

  # Initailizes the component
  # @private
  initialize: ->
    @$close = @_close.bind(@)
    @$open = @_open.bind(@)
    @onAdded() if @parentNode
    document.addEventListener UI.Events.action, @$close
    document.addEventListener 'contextmenu', @$close
    document.body.appendChild(@)

