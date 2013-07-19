Test.add 'iCheckable',->
  component = document.querySelector(UI.Checkbox.SELECTOR())

  @case "Checked should set checked attribute of the component", ->
    component.checked = false
    @assert !component.hasAttribute('checked')
    component.checked = true
    @assert component.hasAttribute('checked')
  @case "Checked should return checked attribute of the component", ->
    @assert component.hasAttribute('checked') is component.checked

  @case "It should not trigger change event if the checked is the same ", ->
    x = false
    component.addEventListener 'change', -> x = true
    component.checked = true
    @assert !x

  @case "It should trigger change event if the checked changes", ->
    x = false
    component.addEventListener 'change', -> x = true
    component.checked = false
    @assert x
    component.checked = true

  @case "It should not change if it is disabled", ->
    @assert component.hasAttribute('checked')
    component.disabled = true
    component.click()
    @assert component.hasAttribute('checked')
    component.disabled = false

  @case "Enter should toggle the component", ->
    @assert component.checked
    component.fireEvent 'keydown', {keyCode: 13}
    @assert !component.checked
    component.fireEvent 'keydown', {keyCode: 13}
    @assert component.checked

  @case 'Checkbox should be valid if required and checked', ->
    component.setAttribute 'required', true
    component.checked = true
    component.validate()
    @assert !component.invalid
    @assert component.valid
    component.value = false
    
  @case 'Checkbox should be invalid if required and not checked', ->
    component.validate()
    @assert component.invalid
    @assert !component.valid
    component.removeAttribute 'required'
