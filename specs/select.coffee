Test.add 'Select',->
  select = document.querySelector(UI.Select.SELECTOR())

  @case "Value property should return selectedOptions value", ->
    @assert select.value is 'option2'

  @case "Value property should select element with value", ->
    @assert select.value is 'option2'
    select.select('option3')
    @assert select.value is 'option3'
    @assert select.selectedOption is document.querySelector('ui-option:nth-child(3)')

  @case "Value property should deselect when no match found", ->
    select.select('null')
    @assert select.value is null
    @assert select.selectedOption is null

  @case "SelectDefault should select first option if no selected option is found", ->
    select.selectDefault()
    @assert select.value is "option1"

  @case "SelectDefault should select selected option if is one", ->
    document.querySelector('ui-option:nth-child(1)').removeAttribute('selected')
    document.querySelector('ui-option:nth-child(3)').setAttribute('selected',true)
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
    select._dropdown.appendChild option
    @assert select.value is "option4"

  @case "When a child option is clicked it should be selected", ->
    document.querySelector('ui-option:nth-child(1)').click()
    @assert select.value is "option1"

  @case "When a child option is clicked it should close the dropdown", ->
    select._dropdown.open()
    @assert select._dropdown.isOpen
    document.querySelector('ui-option:nth-child(1)').click()
    @assert !select._dropdown.isOpen

  @case "Label should be the selectedOptions textContent", ->
    @assert select._label.textContent is document.querySelector('ui-option:nth-child(1)').textContent

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
