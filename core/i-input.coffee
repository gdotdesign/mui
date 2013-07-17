#= require abstract

# Input base Class
# @abstract
class UI.iInput extends UI.Abstract

  @get 'required', -> @hasAttribute 'required'
  @get 'maxlength', -> parseInt(@getAttribute('maxlength')) or Infinity
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

    validatePattern = @pattern.toString() isnt "/^.*$/"
    validateMaxLength = @maxlength isnt Infinity
    validate = @required or @validator instanceof Function

    return undefined if not validatePattern and not validateMaxLength and not validate
    
    if (@required and not @value) or (@maxlength < @value.toString().length) or (not @pattern.test @value) or (@validator?.call(@) or false)
      @toggleAttribute('invalid', true)
      return false

    @toggleAttribute 'valid', true
    true

  # @property [String] value The value of the component
  @get 'value', ->  @textContent
  @set 'value', (value)->
    lastValue = @textContent
    @textContent = value
    if lastValue isnt value
      @fireEvent 'change'

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

  _blur: ->
    @cleanup()
    @validate()

  # Initializes the component
  # @private
  initialize: ->
    @setAttribute 'contenteditable', true
    @addEventListener UI.Events.blur, @_blur
    @addEventListener 'input', @validate
    @addEventListener 'change', @validate
