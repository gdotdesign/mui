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
    return unless @::implements
    cls::initialize.call el for cls in @::implements


  # Creates the specifiec component.
  # @return [UI.Abstract] The component element
  @create: (attributes)->
    base = document.createElement @SELECTOR()
    if @MARKUP
      UI._build.call base, @MARKUP, base
    if attributes
      throw "Illegal attributes" unless typeof attributes is 'object'
      base.setAttribute key, value for key, value of attributes
    @wrap base
    base

  # Returns a function when its called creates a Component
  # @param [Object] Attributes to be added to the component
  # @param [Array] Children to be created for the component
  # @return [Function]
  @promise: (attributes = {}, children)->
    (parent)=>
      el = @create(attributes)
      UI._build.call el, children, parent
      el

  # Returns the string representation of the component
  # @return [String] tagname
  toString: -> "<#{@tagName.toLowerCase()}>"

