Test.add 'Color', ->
  component = document.querySelector(UI.Color.SELECTOR())

  @case 'Value should return hey representation', ->
    @assert component.value is "#FFFFFF"

  @case 'Value should set value', ->
    component.value = '#ff0000'
    @assert component.value is "#FF0000"

  @case 'Value should set the background color', ->
    hex = new ColorType(component.style.backgroundColor).hex
    @assert hex is "#FF0000"

  @case 'Value should set the color', ->
    hex = new ColorType(component.style.color).hex
    @assert hex is "#000000"
    component.value = "#000000"
    hex = new ColorType(component.style.color).hex
    @assert hex is "#FFFFFF"

  @case 'Value should fire the change event', ->
    x = false
    fn = -> x = true
    component.addEventListener 'change', fn
    component.value = "#FFFFFF"
    @assert x