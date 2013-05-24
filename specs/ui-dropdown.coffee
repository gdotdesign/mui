Test.add 'Dropdown',->
  dropdown = document.querySelector(UI.Dropdown.SELECTOR())

  @case "Clicking outside should close the dropdown", ->
    dropdown.toggle()
    @assert dropdown.hasAttribute('open')
    document.body.click()
    @assert !dropdown.hasAttribute('open')

  @case "Clicking the parent element should toggle the dropdown", ->
    @assert !dropdown.isOpen
    dropdown.parentNode.click()
    @assert dropdown.isOpen
    dropdown.parentNode.click()
    @assert !dropdown.isOpen

  @case "Clicking the disabled parent element should not toggle the dropdown", ->
    dropdown.parentNode.setAttribute('disabled',true)
    dropdown.parentNode.click()
    @assert !dropdown.isOpen
    dropdown.parentNode.removeAttribute('disabled')

  @case "Clicking the parent element while in disabled state shoud not toggle the dropdown", ->
    dropdown.disabled = true
    dropdown.parentNode.click()
    @assert !dropdown.isOpen
    dropdown.disabled = false