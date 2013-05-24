#= require ui-text

class UI.Password extends UI.Text
  @TAGNAME: 'password'

  mask: ->
    @setAttribute 'mask', @textContent.replace(/./g,'*')

  initialize: ->
    super
    @addEventListener UI.Events.input, @mask