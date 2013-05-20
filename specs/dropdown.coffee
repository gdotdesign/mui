Test.add 'Dropdown',->
  dropdown = document.querySelector(UI.Dropdown.SELECTOR())

  @case "Toggle should toggle the the open attribute", ->
    @assert !dropdown.hasAttribute('open')
    dropdown.toggle()
    @assert dropdown.hasAttribute('open')
    dropdown.toggle()
    @assert !dropdown.hasAttribute('open')

  @case "Parent node should not be 'static'", ->
    @assert getComputedStyle(dropdown.parentNode).position isnt 'static'

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

  @case "Direction property should set direction attribute", ->
    @assert dropdown.getAttribute('direction') is null
    dropdown.direction = 'top'
    @assert dropdown.getAttribute('direction') is 'top'

  @case "Direction property should return attribute value if direction isnt default", ->
    @assert dropdown.getAttribute('direction') is dropdown.direction

  @case "Direction property should remove attribute direction if value isnt top", ->
    @assert dropdown.getAttribute('direction') is 'top'
    dropdown.direction = 'xxx'
    @assert dropdown.getAttribute('direction') is null

  @case "Direction property should return default if no attribute is present", ->
    @assert !dropdown.hasAttribute('direction')
    @assert dropdown.direction is 'bottom'

  @case "isOpen property should return accordingly", ->
    @assert dropdown.isOpen is false
    dropdown.toggle()
    @assert dropdown.isOpen is true