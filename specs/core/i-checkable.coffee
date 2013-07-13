Test.add 'iCheckable',->
  checkbox = document.querySelector(UI.Checkbox.SELECTOR())

  @case "Checked should set checked attribute of the checkbox", ->
    checkbox.checked = false
    @assert !checkbox.hasAttribute('checked')
    checkbox.checked = true
    @assert checkbox.hasAttribute('checked')
  @case "Checked should return checked attribute of the checkbox", ->
    @assert checkbox.hasAttribute('checked') is checkbox.checked

  @case "It should not trigger change event if the checked is the same ", ->
    x = false
    checkbox.addEventListener 'change', -> x = true
    checkbox.checked = true
    @assert !x

  @case "It should trigger change event if the checked changes", ->
    x = false
    checkbox.addEventListener 'change', -> x = true
    checkbox.checked = false
    @assert x
    checkbox.checked = true

  @case "It should not change if it is disabled", ->
    @assert checkbox.hasAttribute('checked')
    checkbox.disabled = true
    checkbox.click()
    @assert checkbox.hasAttribute('checked')
    checkbox.disabled = false

  @case "Enter should toggle the component", ->
    @assert checkbox.checked
    checkbox.fireEvent 'keydown', {keyCode: 13}
    @assert !checkbox.checked
    checkbox.fireEvent 'keydown', {keyCode: 13}
    @assert checkbox.checked
