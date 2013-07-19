Test.add 'iValidable',->
  component = document.querySelector(UI.Text.SELECTOR())

  @case "Required should return flase if no required attribute is present", ->
    @assert !component.hasAttribute('required')
    @assert !component.required

  @case "Required should return true if required attribute is present", ->
    component.setAttribute('required', true)
    @assert component.required    

  @case "Maxlength should return 0 if no attribute is present", ->
    @assert !component.hasAttribute('maxlength')
    @assert typeof component.maxlength is 'number'
    @assert component.maxlength is Infinity

  @case "Maxlength should return parsed attribute value if attribute is present", ->
    component.setAttribute 'maxlength', 10
    @assert typeof component.maxlength is 'number'
    @assert component.maxlength is 10

  @case "Pattern should return empty regexp if no attribute is present", ->
    @assert !component.hasAttribute('pattern')
    @assert component.pattern instanceof RegExp
    @assert component.pattern.toString() is "/^.*$/"

  @case "Pattern should return empty regexp if attribute is present and not valid", ->
    component.setAttribute 'pattern', ".*"
    @assert component.pattern instanceof RegExp
    @assert component.pattern.toString() is "/^.*$/"

  @case "Pattern should return regexp if attribute is present and valid", ->
    component.setAttribute 'pattern', "\\d+"
    @assert component.pattern instanceof RegExp
    @assert component.pattern.toString() is "/^\\d+$/"

  @case "Input shouldn't be validated if no required, maxlength, pattern and no validator is present", ->
    component.removeAttribute 'required'
    component.removeAttribute 'maxlength'
    component.removeAttribute 'pattern'
    component.validator = undefined
    component.validate()
    @assert !component.valid
    @assert !component.invalid

  @case 'Validate should return undefined if the element is indeterminate', ->
    @assert component.validate() is undefined
    @assert !component.invalid
    @assert !component.valid

  @case 'Validate should return true if the element is valid', ->
    component.setAttribute 'required', true
    component.value = 'a'
    @assert component.validate() is true

  @case 'Validate should return false if the element is invalid', ->
    component.value = ''
    @assert component.validate() is false
    component.removeAttribute 'required'

  @case 'Input should be invalid if required and no value', ->
    component.setAttribute 'required', true
    component.validate()
    @assert component.invalid
    @assert !component.valid

  @case 'Input should be valid if required and value', ->
    component.value = '123'
    component.validate()
    @assert !component.invalid
    @assert component.valid
    component.removeAttribute 'required'
    component.value = ''

  @case 'Input should be invalid if maxlength and value.length is bigger then maxlength', ->
    component.setAttribute 'maxlength', 5
    component.value = "123456"
    component.validate()
    @assert component.invalid
    @assert !component.valid

  @case 'Input should be valid if maxlength and value.length is lower then maxlength', ->
    component.value = "12345"
    component.validate()
    @assert !component.invalid
    @assert component.valid
    component.removeAttribute 'maxlength'
    component.value = ''

  @case 'Input should be invalid if value isnt match pattern', ->
    component.setAttribute 'pattern', "\\d+"
    component.value = 'abc'
    component.validate()
    @assert !component.valid
    @assert component.invalid

  @case 'Input should be valid if value matches pattern', ->
    component.setAttribute 'pattern', "\\d+"
    component.value = '123'
    component.validate()
    @assert component.valid
    @assert !component.invalid
    component.removeAttribute 'pattern'
    component.value = ''

  @case 'Input should be invalid if validator returns false', ->
    UI.Text::validators.push
      condition: -> true
      validate: -> if @value is 'a' then true else false
    component.validate()
    @assert component.invalid
    @assert !component.valid

  @case 'Input should be valid if validator returns empty string', ->
    component.value = 'a'
    component.validate()
    @assert !component.invalid
    @assert component.valid
    delete UI.Text::validators.splice(UI.Text::validators.length-1,1)
    component.value = ''

  @case 'Input should fire validate event when validating (true)', ->
    x = false
    e = null
    fn = (ev)->
      x = true
      e = ev
    component.setAttribute 'required', true
    component.addEventListener 'validate', fn
    component.value = 'a'
    @assert x
    @assert e.valid
    component.removeEventListener 'validate', fn

  @case 'Input should fire validate event when validating (false)', ->
    x = false
    e = null
    fn = (ev)->
      x = true
      e = ev
    component.setAttribute 'required', true
    component.addEventListener 'validate', fn
    component.value = ''
    @assert x
    @assert !e.valid
    component.removeEventListener 'validate', fn