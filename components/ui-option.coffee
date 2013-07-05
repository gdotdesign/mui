#= require ../core/abstract

# Option component for Select component
class UI.Option extends UI.Abstract
  # The tagname of the component
  @TAGNAME: 'option'

  # @property [Boolean] Returns true if the component is selected false otherwise
  @get 'selected', -> @hasAttribute 'selected'
  @set 'selected', (value) -> @toggleAttribute 'selected', !!value

  @create: (value)->
    el = super
    el.setAttribute 'value', value
    el.textContent = value
    el