Test.add 'Page', ->
  component = document.querySelector(UI.Page.SELECTOR())

  @case "Active property should be aliased for active attribute", ->
    @assert !component.hasAttribute('active')
    component.active = true
    @assert component.hasAttribute('active')
    component.active = false
    @assert !component.hasAttribute('active')