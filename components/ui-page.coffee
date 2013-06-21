#= require ../core/abstract

# Page component for Pager component
class UI.Page extends UI.Abstract
  # The tagname of the component
  @TAGNAME: 'page'

  # @property [Boolean] Returns true if the component is active flase otherwise
  @get 'active', -> !!@getAttribute 'active'
  @set 'active', (value) -> @toggleAttribute 'active', !!value