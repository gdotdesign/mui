#= require abstract

# Toggle button (iOS Style) component
class UI.Toggle extends UI.iCheckable
  # The tagname of the component
  @TAGNAME: 'toggle'
  # Child Elements
  @MARKUP: [
    UI.promiseElement('div',{},['ON'])
    UI.promiseElement('div')
    UI.promiseElement('div',{},['OFF'])
  ]

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
