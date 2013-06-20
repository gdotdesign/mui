#= require abstract

# Input base Class
# @abstract
class UI.iInput extends UI.Abstract

  # @property [String] value The value of the component
  @get 'value', ->  @textContent
  @set 'value', (value)-> @textContent = value

  # @property [Boolean] The component is disabled or not
  @get 'disabled', ->
  @set 'disabled', (value) ->
    @toggleAttribute 'disabled', !!value
    @toggleAttribute 'contenteditable', !value

  # Initializes the component
  # @private
  initialize: ->
    @setAttribute('contenteditable',true)
    @_input = document.createElement('input')
    @addEventListener 'blur', (e) ->
      if @childNodes.length is 1
        if @childNodes[0].tagName is 'BR'
          @removeChild @childNodes[0]