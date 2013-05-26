Test.add 'Dropdown',->
  dropdown = document.querySelector(UI.Dropdown.SELECTOR())

  @case "Triggerin action outside should close the dropdown", ->
    dropdown.toggle()
    @assert dropdown.hasAttribute('open')
    document.body.action()
    @assert !dropdown.hasAttribute('open')

  @case "Triggerin action the parent element should toggle the dropdown", ->
    @assert !dropdown.isOpen
    dropdown.parentNode.action()
    @assert dropdown.isOpen
    dropdown.parentNode.action()
    @assert !dropdown.isOpen

  @case "Triggerin action the disabled parent element should not toggle the dropdown", ->
    dropdown.parentNode.setAttribute('disabled',true)
    dropdown.parentNode.action()
    @assert !dropdown.isOpen
    dropdown.parentNode.removeAttribute('disabled')

  @case "Triggerin action the parent element while in disabled state shoud not toggle the dropdown", ->
    dropdown.disabled = true
    dropdown.parentNode.action()
    @assert !dropdown.isOpen
    dropdown.disabled = false