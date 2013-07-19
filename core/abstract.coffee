#= require ui

# Abstract Base Class
#
# This is the base class for all components. Extend this if you want to create a custom component.
# @abstract
class UI.Abstract

  # @property [Boolean] The component is disabled or not
  @get 'disabled', -> @hasAttribute 'disabled'
  @set 'disabled', (value) -> @toggleAttribute 'disabled', !!value

  # Get the selector for the component
  # @return [String] selector
  @SELECTOR: -> UI.namespace+"-"+@TAGNAME

  # Wraps an HTMLElement with associeted components methods.
  # Calls initialize method and onAdded if the element is in the DOM.
  #
  # @param [Element] el The element to be wrapped
  # @private
  @wrap: (el)->
    for key, desc of UI._geather @::
      continue if key is 'initialize' or key is 'constructor'
      Object.defineProperty el, key, desc

    el.setAttribute 'tabindex', 0 if @TABABLE
    el._processed = true

    @::initialize?.call el
    if @::implements
      for cls in @::implements
        cls::initialize.call el
    el.onAdded?() if el.parentNode

  # Creates the specifiec component.
  # @return [UI.Abstract] The component element
  @create: ->
    base = document.createElement @SELECTOR()
    @wrap base
    base

  # Returns the string representation of the component
  # @return [String] tagname
  toString: -> "<#{@tagName.toLowerCase()}>"