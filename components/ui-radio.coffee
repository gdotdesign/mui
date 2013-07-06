#= require ui-checkbox

# Radio Component
class UI.Radio extends UI.iCheckable
  # The tagname of the component
  @TAGNAME: 'radio'

  # @property [Boolean] Returns true if the component is checked otherwise false
  @get 'checked', -> @hasAttribute 'checked'
  @set 'checked', (value)->
    value = !!value
    return if @checked is value
    unless value
      next = document.querySelector(UI.Radio.SELECTOR()+"[name='#{@getAttribute('name')}']:not([checked])")
      return unless next
      changed = !next.checked
      next.setAttribute 'checked', true
      next.fireEvent 'change' if changed
    else
      for radio in document.querySelectorAll(UI.Radio.SELECTOR()+"[name='#{@getAttribute('name')}']")
        continue if radio is @
        changed = radio.checked
        radio.removeAttribute 'checked'
        radio.fireEvent 'change' if changed
    @toggleAttribute 'checked', value
    @fireEvent 'change'

  # Action event handler
  # @private
  _toggle: ->
    return if @checked
    super