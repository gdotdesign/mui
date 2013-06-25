Test.add 'Grid', ->
  component = document.querySelector(UI.Grid.SELECTOR())

  @case "Columns property should be aliased for columns attribute", ->
    @assert component.columns.toString() is component.getAttribute('columns')
    component.columns = 5
    @assert component.getAttribute('columns') is "5"

  @case "Update should update the placeholder", ->
    @assert document.querySelectorAll(UI.Placeholder.SELECTOR()).length is 1
    component.columns = 4
    @assert document.querySelectorAll(UI.Placeholder.SELECTOR()).length is 3