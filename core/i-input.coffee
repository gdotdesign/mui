#= require abstract

# Input base Class
# @abstract
class UI.iInput extends UI.Abstract

  # @property [String] value The value of the component
  @get 'value', ->  @textContent
  @set 'value', (value)-> @textContent = value

  # @property [Boolean] The component is disabled or not
  @get 'disabled', -> @hasAttribute 'disabled'
  @set 'disabled', (value) ->
    @toggleAttribute 'disabled', !!value
    @toggleAttribute 'contenteditable', !value

  # Removes empty text
  cleanup: ->
    return unless @childNodes.length is 1
    return unless @childNodes[0].tagName is 'BR'
    @removeChild @childNodes[0]

  # Initializes the component
  # @private
  initialize: ->
    @setAttribute 'contenteditable', true
    @addEventListener 'blur', @cleanup.bind(@)