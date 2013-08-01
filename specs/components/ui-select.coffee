Test.add 'Select',->
  select = document.querySelector(UI.Select.SELECTOR())

  @case "Value property should return selectedOptions value", ->
    @assert select.value is 'option2'

  @case "Value property should select element with value", ->
    @assert select.value is 'option2'
    select.select('option3')
    @assert select.value is 'option3'
    @assert select.selectedOption is document.querySelector('ui-select ui-option:nth-child(3)')

  @case "Value property should deselect when no match found", ->
    select.select('null')
    @assert select.value is null
    @assert select.selectedOption is null

  @case "SelectDefault should select first option if no selected option is found", ->
    select.selectDefault()
    @assert select.value is "option1"

  @case "SelectDefault should select selected option if is one", ->
    document.querySelector('ui-select ui-option:nth-child(1)').removeAttribute('selected')
    document.querySelector('ui-select ui-option:nth-child(3)').setAttribute('selected',true)
    select.selectDefault()
    @assert select.value is "option3"

  @case "SelectedOption should return selected option", ->
    @assert select.selectedOption is document.querySelector('ui-option:nth-child(3)')

  @case "Select should select default if selected option is removed", ->
    @assert select.value is "option3"
    option = document.querySelector('ui-option:nth-child(3)')
    option.parentNode.removeChild option
    @assert select.value is "option1"

  @case "Select should select default if option is added", ->
    select.select null
    option = document.createElement('ui-option')
    option.setAttribute('value','option4')
    option.setAttribute('selected', true)
    option.textContent = 'Option 4'
    select.dropdown.appendChild option
    @assert select.value is "option4"

  @case "When a child option is actioned it should be selected", ->
    document.querySelector('ui-select ui-option:nth-child(1)').action()
    @assert select.value is "option1"

  @case "When a child option is actioned it should close the dropdown", ->
    select.dropdown.open()
    @assert select.dropdown.isOpen
    select.fireEvent 'blur'
    @assert !select.dropdown.isOpen

  @case "Label should be the selectedOptions textContent", ->
    @assert select.label.textContent is document.querySelector('ui-select ui-option:nth-child(1)').textContent

  @case "It should not fire change event if selecting the same value", ->
    x = true
    select.addEventListener 'change', ->
      x = false
    select.select('option1')
    @assert x

  @case "It should fire change event if selecting an other value", ->
    x = true
    select.addEventListener 'change', ->
      x = false
    select.select('option2')
    @assert !x

  @case "It should fire change event if selecting null from a value", ->
    x = true
    select.addEventListener 'change', ->
      x = false
    select.select(null)
    @assert !x
    select.selectDefault()

  @case "Focus should open color picker", ->
    @assert !select.dropdown.isOpen
    select.fireEvent 'focus'
    @assert select.dropdown.isOpen

  @case "Blur should close color picker", ->
    select.fireEvent 'blur'
    @assert !select.dropdown.isOpen

  @case 'Right / Up button should select next option', ->
    @assert select.selectedOption.index() is 0
    select.fireEvent 'keydown', {keyCode: 39}
    @assert select.selectedOption.index() is 1
    select.fireEvent 'keydown', {keyCode: 40}
    @assert select.selectedOption.index() is 2
    select.fireEvent 'keydown', {keyCode: 40}
    @assert select.selectedOption.index() is 3

  @case 'Right / Up button shouldnot select anything if the last option is selected', ->
    @assert select.selectedOption.index() is 3
    select.fireEvent 'keydown', {keyCode: 40}
    select.fireEvent 'keydown', {keyCode: 39}
    @assert select.selectedOption.index() is 3

  @case 'Left / Down button should select previous option', ->
    select.fireEvent 'keydown', {keyCode: 37}
    @assert select.selectedOption.index() is 2
    select.fireEvent 'keydown', {keyCode: 38}
    @assert select.selectedOption.index() is 1
    select.fireEvent 'keydown', {keyCode: 38}
    @assert select.selectedOption.index() is 0

  @case 'Left / Down button shouldnot select anything if the fisrt option is selected', ->
    @assert select.selectedOption.index() is 0
    select.fireEvent 'keydown', {keyCode: 37}
    select.fireEvent 'keydown', {keyCode: 38}
    @assert select.selectedOption.index() is 0

  @case 'Component should be valid if required and not empty value', ->
    select.setAttribute 'required', true
    select.validate()
    @assert !select.invalid
    @assert select.valid

  @case 'Component should be invalid if required and empty value', ->
    select.select("")
    select.validate()
    @assert select.invalid
    @assert !select.valid
    select.removeAttribute 'required'
