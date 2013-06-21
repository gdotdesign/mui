#= require ../core/abstract

class UI.Option extends UI.Abstract
  @TAGNAME: 'option'

  @get 'selected', -> @hasAttribute 'selected'
  @set 'selected', (value) -> @toggleAttribute 'selected', !!value