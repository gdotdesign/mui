# Validable mixin
class UI.iValidable

  # @property [Boolean] Whether the component value is required or not
  @get 'required', -> @hasAttribute 'required'

  # @property [Number] Maximum length allows fot the components value
  @get 'maxlength', -> parseInt(@getAttribute('maxlength')) or Infinity

  # @property [Boolean] Whether the component is valid
  @get 'valid', -> @hasAttribute 'valid'

  # @property [Boolean] Whether the component is invalid
  @get 'invalid', -> @hasAttribute 'invalid'

  # @property [RegExp] The pattern to match against the value
  @get 'pattern', -> 
    pattern = @getAttribute('pattern') or ".*"
    try
      return new RegExp "^#{pattern}$"
    catch
      return /^.*$/

  # Validates to components value based on @validators
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
        @fireEvent 'validate', {valid: false}
        return false

    @toggleAttribute 'valid', true
    @fireEvent 'validate', {valid: true}
    true

  # Initailizes the mixin
  # @private
  initialize: ->
    @addEventListener 'keyup', @validate
    @addEventListener 'change', @validate
    @validate()