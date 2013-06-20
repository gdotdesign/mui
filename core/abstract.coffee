#= require ui

# Abstract Base Class
# @abstract
class UI.Abstract

  # @property [Boolean] The component is disabled or not
  @get 'disabled', -> @hasAttribute('disabled')
  @set 'disabled', (value) ->
      value = !!value
      if value
        @setAttribute('disabled',true)
      else
        @removeAttribute('disabled')

  # Get the selector for the component
  # @return [String] selector
  @SELECTOR: -> UI.ns+"-"+@TAGNAME

  # Wraps an HTMLElement with associeted components methods.
  # Calls initialize method and onAdded if the element is in the DOM.
  #
  # @param [Element] el The element to be wrapped
  # @private
  @wrap: (el)->
    for key, desc of UI._geather @::
      if key isnt 'initialize' and key isnt 'constructor'
        Object.defineProperty el, key, desc

    el._processed = true
    @::initialize?.call el
    el.onAdded?() if el.parentNode

  # Creates the specifiec component.
  # @return [UI.Abstract] The component element
  @create: ->
    base = document.createElement(@SELECTOR())
    @wrap base
    base

  # Fires an event
  # @return [Event] The event
  #
  # @param [String] type - The type of the event
  # @param [Object] data - The additional parameters to be set on the event
  fireEvent: (type,data)->
    event = document.createEvent("HTMLEvents")
    event.initEvent(type, true, true)
    for key, value of data
      event[key] = value
    @dispatchEvent(event)
    event

  # Returns the string representation of the component
  # @return [String] tagname
  toString: ->
    "<#{@tagName.toLowerCase()}>"