#= require ui-checkbox

# Radio Component
class UI.Radio extends UI.iCheckable
  # The tagname of the component
  @TAGNAME: 'radio'

  # Toggles the component checked state unless disabled.
  # Unchecks any other radio components with the same name.
  # @return [Boolean] The new state
  toggle: ->
    return if @checked
    super
    for radio in document.querySelectorAll(UI.Radio.SELECTOR()+"[name='#{@getAttribute('name')}']")
      continue if radio is @
      radio.checked = false