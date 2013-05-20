Test.add 'iOpenable',->
  dropdown = document.querySelector(UI.Dropdown.SELECTOR())

  @case "Toggle should toggle the the open attribute", ->
    @assert !dropdown.hasAttribute('open')
    dropdown.toggle()
    @assert dropdown.hasAttribute('open')
    dropdown.toggle()
    @assert !dropdown.hasAttribute('open')

  @case "Parent node should not be 'static'", ->
    @assert getComputedStyle(dropdown.parentNode).position isnt 'static'

  @case "Direction property should set direction attribute", ->
    @assert dropdown.getAttribute('direction') is null
    dropdown.direction = 'top'
    @assert dropdown.getAttribute('direction') is 'top'

  @case "Direction property should return attribute value if direction isnt default", ->
    @assert dropdown.getAttribute('direction') is dropdown.direction

  @case "Direction property should remove attribute direction if value isnt valid", ->
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
    dropdown.toggle()