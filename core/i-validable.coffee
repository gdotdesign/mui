class UI.iValidable

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

  initialize: ->
    @addEventListener 'input', @validate
    @addEventListener 'change', @validate