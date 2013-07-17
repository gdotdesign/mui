Test.add 'iInput',->
  component = document.querySelector(UI.Text.SELECTOR())

  @case "Value should get/set textContent", ->
    component.textContent = "WTF"
    @assert component.value if component.textContent
    component.value = ""
    @assert component.textContent is ""

  @case "Disabled should also toggle contenteditable", ->
    component.disabled = true
    @assert !component.hasAttribute('contenteditable')
    component.disabled = false
    @assert component.hasAttribute('contenteditable')

  @case "Cleanup should remove only br tag", ->
    component.appendChild document.createElement 'br'
    @assert component.children.length is 1
    component.cleanup()
    @assert component.children.length is 0

  @case "Cleanup should normalize tag", ->
    component.textContent = "\t\n"
    @assert component.textContent.length is 2
    component.cleanup()
    @assert component.textContent.length is 0

  @case "Should set contenteditable on initialize", ->
    el = UI.Text.create()
    @assert component.hasAttribute('contenteditable')

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
    component.setAttribute 'pattern', "*"
    @assert component.pattern instanceof RegExp
    @assert component.pattern.toString() is "/^.*$/"

  @case "Pattern should return regexp if attribute is present and valid", ->
    component.setAttribute 'pattern', "https?://.+"
    @assert component.pattern instanceof RegExp
    @assert component.pattern.toString() is "/^https?://.+$/"

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

  @case 'Validate should return true if the element is valid', ->
    component.setAttribute 'required', true
    component.value = 'a'
    @assert component.validate() is true

  @case 'Validate should return false if the element is invalid', ->
    component.setAttribute 'required', true
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

  @case 'Input should be invalid if validator returns non empty string', ->
    component.validator = -> if @value is 'a' then '' else 'ASDASDASD'
    component.validate()
    @assert component.invalid
    @assert !component.valid

  @case 'Input should be valid if validator returns empty string', ->
    component.value = 'a'
    component.validate()
    @assert !component.invalid
    @assert component.valid
    component.validator = null
    component.value = ''

  @case 'Input should not throw if validator is null', ->
    try
      component.validate()
      @assert true
    catch
      @assert false

  @case 'Input should not throw if validator is undefined', ->
    component.validator = undefined
    try
      component.validate()
      @assert true
    catch
      @assert false

  @case 'Input should not throw if validator isnt function', ->
    component.validator = "asd"
    try
      component.validate()
      @assert true
    catch
      @assert false