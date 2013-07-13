#= require abstract

# Toggle button (iOS Style) component
class UI.Toggle extends UI.iCheckable
  # The tagname of the component
  @TAGNAME: 'toggle'

  # Keydown event handler
  # @param [Event] e
  # @private
  _keydown: (e)->
    return if [37,38,39,40].indexOf(e.keyCode) is -1
    switch e.keyCode
      when 37, 38 # LEFT
        @checked = false
      when 39, 40 # RIGHT
        @checked = true

  # Initializes the component
  # @private
  initialize: ->
    super
    @addEventListener 'keydown', @_keydown

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