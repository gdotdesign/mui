#= require ui-text

# Number component
class UI.Number extends UI.Text
  # The tagname of the component
  @TAGNAME: 'number'

  # @property [String] value The value of the component
  @get 'value', -> parseFloat(@textContent)
  @set 'value', (value)->
    value = parseFloat(value)
    value = '' if isNaN(value)
    @textContent = value

  # Keypress event handler
  # @param [Event] e
  # @private
  _keypress: (e)->
    # BUGFIX[Firefox] Allow arrows to work
    return if [39,37,8,46].indexOf(e.keyCode) isnt -1
    unless /^[0-9.]$/.test String.fromCharCode(e.charCode)
      e.preventDefault()

  # Shortcut for change event
  _change: -> @fireEvent 'change'

  # Initializes the component
  # @private
  initialize: ->
    super
    @addEventListener 'keypress', @_keypress
    @addEventListener 'keyup', @_change
    @addEventListener 'blur', @_change