#= require ../core/abstract

class UI.Label extends UI.Abstract
  @TAGNAME: 'label'

  _redirect: ->
    target = document.querySelector("[name='#{@getAttribute('for')}']")
    return unless target
    target.focus()
    target.click()

  initialize: ->
    @addEventListener UI.Events.action, @_redirect