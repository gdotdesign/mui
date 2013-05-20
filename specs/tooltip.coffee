fireMouseEvent = (element,type)->
  e = document.createEvent("MouseEvent")
  e.initEvent type, true, true
  element.dispatchEvent e

Test.add 'Tooltip',->
  tooltip = document.querySelector(UI.Tooltip.SELECTOR())

  @case "Mouse over the parent element should open the tooltip", ->
    @assert !tooltip.isOpen
    fireMouseEvent tooltip.parentNode, 'mouseover'
    @assert tooltip.isOpen

  @case "Mouse out the parent element should close the tooltip", ->
    tooltip.open()
    @assert tooltip.isOpen
    fireMouseEvent tooltip.parentNode, 'mouseout'
    @assert !tooltip.isOpen

  @case "Mouse over the disabled parent element should not open the tooltip", ->
    @assert !tooltip.isOpen
    tooltip.parentNode.setAttribute('disabled',true)
    fireMouseEvent tooltip.parentNode, 'mouseover'
    @assert !tooltip.isOpen
    tooltip.parentNode.removeAttribute('disabled')

  @case "Mouse over the parent element while in disabled state should not open the tooltip", ->
    @assert !tooltip.isOpen
    tooltip.disabled = true
    fireMouseEvent tooltip.parentNode, 'mouseover'
    @assert !tooltip.isOpen