Test.add 'Context',->
  component = document.querySelector(UI.Context.SELECTOR())

  @case 'Triggering the contextmenu on the parentNode should open the component', ->
    UI.Abstract::fireEvent.call component.parent, 'contextmenu'
    @assert component.hasAttribute('open')

  @case 'Triggering the action on something else should close the component', ->
    UI.Abstract::fireEvent.call document.body, UI.Events.action
    @assert !component.hasAttribute('open')    