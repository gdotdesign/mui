#= require ../ui-text/component

class UI.Password extends UI.Text
  @TAGNAME: 'password'
  initialize: ->
    super
    @addEventListener 'input', (e) ->
      @setAttribute 'mask', @textContent.replace(/./g,'*')