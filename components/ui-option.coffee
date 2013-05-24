#= require ../core/abstract

class UI.Option extends UI.Abstract
  @TAGNAME: 'option'

  initialize: ->
    Object.defineProperty @, 'selected',
      get: -> !!@getAttribute 'selected'
      set: (value) -> @toggleAttribute 'selected', !!value