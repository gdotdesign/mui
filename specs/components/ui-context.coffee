Test.add 'Context',->
  component = document.querySelector(UI.Context.SELECTOR())

  @case 'Triggering the contextmenu on the parentNode should open the component', ->
    component._parentNode.fireEvent 'contextmenu'
    @assert component.hasAttribute('open')

  @case 'Triggering the action on something else should close the component', ->
    document.body.fireEvent UI.Events.action
    @assert !component.hasAttribute('open')
