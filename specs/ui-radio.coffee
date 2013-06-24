Test.add 'Radio', ->
  @case 'Toggle should deselect other radios with the same name', ->
    radios = document.querySelectorAll(UI.Radio.SELECTOR()+"[name]:not([checked])")
    @assert radios.length is 2
    radios[0].toggle()
    radios = document.querySelectorAll(UI.Radio.SELECTOR()+"[name]:not([checked])")
    @assert radios.length is 2