Test.add 'Text', ->
  component = document.querySelector(UI.Text.SELECTOR())

  @case 'It should prevent event when enter is pressed', ->
    x = false
    component.addEventListener UI.Events.beforeInput, (e)->
      x = e.defaultPrevented
    component.fireEvent UI.Events.beforeInput, {keyCode: 13}
    @assert x