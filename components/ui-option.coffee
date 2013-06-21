#= require ../core/abstract

# Option component for Select component
class UI.Option extends UI.Abstract
  @TAGNAME: 'option'

  # @property [Boolean] Returns true if the component is selected false otherwise
  @get 'selected', -> @hasAttribute 'selected'
  @set 'selected', (value) -> @toggleAttribute 'selected', !!value