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

    shouldValidate = false
    for validator in @validators
      if validator.condition.call @
        shouldValidate = true
        break

    return undefined unless shouldValidate
    
    for validator in @validators
      continue unless validator.condition.call @
      unless validator.validate.call @
        @toggleAttribute 'invalid', true
        return false

    @toggleAttribute 'valid', true
    true

  initialize: ->
    @addEventListener 'input', @validate
    @addEventListener 'change', @validate
    @validate()