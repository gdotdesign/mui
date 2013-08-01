Test.add 'Popover',->
  component = document.querySelector(UI.Popover.SELECTOR())

  @case "Triggering action on the parent element should toggle the componen", ->
    @assert !component.isOpen
    component.parentNode.fireEvent UI.Events.action
    @assert component.isOpen
    component.parentNode.fireEvent UI.Events.action
    @assert !component.isOpen

  @case "Triggering action on the parent element when the component is disabled shouldn't toggle the component", ->
    component.disabled = true
    @assert !component.isOpen
    component.parentNode.fireEvent UI.Events.action
    @assert !component.isOpen
    component.disabled = false

  @case "Triggering action on the parent element when it is disabled shouldn't toggle the component", ->
    component.parentNode.setAttribute 'disabled', true
    @assert !component.isOpen
    component.parentNode.fireEvent UI.Events.action
    @assert !component.isOpen
    component.parentNode.removeAttribute 'disabled'

  @case "Ctrlkey should toggle the component", ->
    @assert !component.isOpen
    component.parentNode.fireEvent 'keydown', {ctrlKey: true}
    @assert component.isOpen
    component.parentNode.fireEvent 'keydown', {ctrlKey: true}
    @assert !component.isOpen