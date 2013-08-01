fireMouseEvent = (element,type)->
  e = document.createEvent("MouseEvent")
  e.initEvent type, true, true
  element.dispatchEvent e

Test.add 'Tooltip',->
  tooltip = document.querySelector(UI.Tooltip.SELECTOR())

  @case "Entering the parent element should open the tooltip", ->
    @assert !tooltip.isOpen
    fireMouseEvent tooltip.parentNode, UI.Events.enter
    @assert tooltip.isOpen

  @case "Leaving the parent element should close the tooltip", ->
    tooltip.open()
    @assert tooltip.isOpen
    fireMouseEvent tooltip.parentNode, UI.Events.leave
    @assert !tooltip.isOpen

  @case "Entering the disabled parent element should not open the tooltip", ->
    @assert !tooltip.isOpen
    tooltip.parentNode.setAttribute('disabled',true)
    fireMouseEvent tooltip.parentNode, UI.Events.enter
    @assert !tooltip.isOpen
    tooltip.parentNode.removeAttribute('disabled')

  @case "Entering the parent element while in disabled state should not open the tooltip", ->
    @assert !tooltip.isOpen
    tooltip.disabled = true
    fireMouseEvent tooltip.parentNode, UI.Events.enter
    @assert !tooltip.isOpen
    tooltip.disabled = false

  @case "Alt should toggle the component", ->
    @assert !tooltip.isOpen
    tooltip.fireEvent 'keydown', {altKey: true}
    @assert tooltip.isOpen
    tooltip.fireEvent 'keydown', {altKey: true}
    @assert !tooltip.isOpen