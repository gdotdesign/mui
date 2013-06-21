#= require ../core/abstract

# Label component
class UI.Label extends UI.Abstract
  # The tagname of the component
  @TAGNAME: 'label'

  # Action event handler
  # Focuses the element associated with this component.
  # @private
  _redirect: ->
    target = document.querySelector("[name='#{@getAttribute('for')}']")
    return unless target
    target.focus()
    target.action()

  # Initializes the component
  # @private
  initialize: -> @addEventListener UI.Events.action, @_redirect