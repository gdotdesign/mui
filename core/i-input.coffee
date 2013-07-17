#= require abstract

# Input base Class
# @abstract
class UI.iInput extends UI.Abstract

  @get 'required', -> @hasAttribute 'required'
  @get 'maxlength', -> parseInt(@getAttribute('maxlength')) or 0
  @get 'valid', -> @hasAttribute 'valid'
  @get 'invalid', -> @hasAttribute 'invalid'

  @get 'pattern', -> 
    pattern = @getAttribute('pattern') or ".*"
    try
      return new RegExp "^#{pattern}$"
    catch
      return /^.*$/

  validate: ->
    @toggleAttribute 'invalid', false
    @toggleAttribute 'valid', false

    if (@required and not @value) or (@maxlength < @value.toString().length) or (not @pattern.test @value) or (not (@validator?() or true))
      return @toggleAttribute('invalid', true) 
    @toggleAttribute 'valid', true

  # @property [String] value The value of the component
  @get 'value', ->  @textContent
  @set 'value', (value)-> @textContent = value

  # @property [String] value The placeholder of the component
  @get 'placeholder', ->  @getAttribute('placeholder')
  @set 'placeholder', (value)-> @setAttribute 'placeholder', value

  # @property [Boolean] The component is disabled or not
  @get 'disabled', -> @hasAttribute 'disabled'
  @set 'disabled', (value) ->
    @toggleAttribute 'disabled', !!value
    @toggleAttribute 'contenteditable', !value

  # Removes empty text
  cleanup: ->
    @normalize()
    return unless @childNodes.length is 1
    if @childNodes[0].tagName is 'BR'
      @removeChild @childNodes[0]
    else if @childNodes[0].nodeType is 3
      @childNodes[0].textContent = @childNodes[0].textContent.trim()

  # Initializes the component
  # @private
  initialize: ->
    @setAttribute 'contenteditable', true
    @addEventListener UI.Events.blur, @cleanup
    @addEventListener 'input', @validate