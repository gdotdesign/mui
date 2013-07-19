Test.add 'Toggle',->
  component = document.querySelector(UI.Toggle.SELECTOR())

  @case 'Left / Down button should uncheck the component', ->
    component.checked = true
    component.fireEvent 'keydown', {keyCode: 37}
    @assert !component.checked
    component.checked = true
    component.fireEvent 'keydown', {keyCode: 38}
    @assert !component.checked

  @case 'Right / Up button should check the component', ->
    component.checked = false
    component.fireEvent 'keydown', {keyCode: 39}
    @assert component.checked
    component.checked = false
    component.fireEvent 'keydown', {keyCode: 40}
    @assert component.checked