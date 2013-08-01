Test.add 'Number',->
  component = document.querySelector(UI.Number.SELECTOR())

  @case 'Component should be valid if required and not empty value', ->
    component.setAttribute 'required', true
    component.value = 1
    component.validate()
    @assert !component.invalid
    @assert component.valid
    component.value = 0
    
  @case 'Component should be invalid if required and empty value', ->
    component.validate()
    @assert component.invalid
    @assert !component.valid
    component.removeAttribute 'required'
