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


