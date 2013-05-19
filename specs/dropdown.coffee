Test.add 'Dropdown',->
  dropdown = document.querySelector(UI.Dropdown.SELECTOR())

  # Attributes
  @case "Toggle should toggle the the open attribute", ->
    @assert !dropdown.hasAttribute('open')
    dropdown.toggle()
    @assert dropdown.hasAttribute('open')
    dropdown.toggle()
    @assert !dropdown.hasAttribute('open')

  @case "Parent node should not be 'static'", ->
    @assert getComputedStyle(dropdown.parentNode).position isnt 'static'

  @case "Clicking outside the should close the dropdown", ->
    dropdown.toggle()
    @assert dropdown.hasAttribute('open')
    document.body.click()
    @assert !dropdown.hasAttribute('open')

