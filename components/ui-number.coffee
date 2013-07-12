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

  # Initializes the component
  # @private
  initialize: ->
    super

    # Only allow [0-9.] to be added
    @addEventListener 'keypress', (e)->
      # BUGFIX[Firefox] Allow arrows to work
      return if [39,37,8,46].indexOf(e.keyCode) isnt -1
      unless /^[0-9.]$/.test String.fromCharCode(e.charCode)
        e.preventDefault()

    @addEventListener 'keyup', -> @fireEvent 'change'
    @addEventListener 'blur', -> @fireEvent 'change'