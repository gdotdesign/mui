#= require abstract

# Toggle button (iOS Style) component
class UI.Toggle extends UI.iCheckable
  # The tagname of the component
  @TAGNAME: 'toggle'

  # Creates the specifiec component.
  # @return [UI.Toggle] The component element
  @create: ->
    el = super
    _on = document.createElement('div')
    _off = document.createElement('div')
    separator = document.createElement('div')

    _on.textContent = 'ON'
    _off.textContent = 'OFF'

    el.appendChild _on
    el.appendChild separator
    el.appendChild _off

    el