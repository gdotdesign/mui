Test.add 'Slider', ->
  @case 'Setting value should set background size', ->
    component = document.querySelector(UI.Slider.SELECTOR()+'[name]')
    @assert component.style.backgroundSize is '10% 100%'
    component.value = 0
    @assert component.style.backgroundSize is '50% 100%'