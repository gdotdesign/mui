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
    @assert component.maxlength is 0

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

  @case "Input should be valid if no required, maxlength, pattern and no validator is present", ->
    component.removeAttribute 'required'
    component.removeAttribute 'maxlength'
    component.removeAttribute 'pattern'
    component.validator = undefined

    component.validate()
    @assert component.valid
    @assert !component.invalid

  @case 'Input should be invalid if required and no value', ->
    component.setAttribute 'required', true
    component.validate()
    @assert component.invalid
    @assert !component.valid
    component.removeAttribute 'required'

  @case 'Input should be invalid if maxlength and value.length is bigger then length', ->
    component.setAttribute 'maxlength', 5
    component.value = "123456"
    component.validate()
    @assert component.invalid
    @assert !component.valid