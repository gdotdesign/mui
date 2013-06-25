Test.add 'Option', ->
  component = document.querySelector(UI.Option.SELECTOR())

  @case "Selected property should be aliased for selected attribute", ->
    @assert !component.hasAttribute('selected')
    component.selected = true
    @assert component.hasAttribute('selected')
    component.selected = false
    @assert !component.hasAttribute('selected')