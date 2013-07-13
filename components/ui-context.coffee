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
      {left, top} = @parent.getBoundingClientRect()
    @style.left = left+"px"
    @style.top = top+"px"
    @setAttribute 'open', true

  # Closes the context menu
  close: ->
    @removeAttribute 'open'

  # Runs when the element is inserted into the DOM
  # @private
  onAdded: ->
    return if @_added
    @_added = true
    @parent = @parentNode

    document.addEventListener UI.Events.action, @_close.bind(@)
    document.addEventListener 'contextmenu', @_close.bind(@)
    document.body.appendChild(@)
    
    @parent.addEventListener 'contextmenu', @_open.bind(@)