#= require ../core/abstract

class UI.Grid extends UI.Abstract
  @TAGNAME: 'grid'

  initialize: ->
    update = =>
      placeholders = @querySelectorAll('ui-placeholder').length
      cells = @querySelectorAll('ui-cell').length
      diff = @columns-cells%@columns
      if placeholders < diff
        for i in [1..diff-placeholders]
          @appendChild document.createTextNode('\u0020')
          @appendChild document.createElement 'ui-placeholder'

    Object.defineProperty @, 'columns',
      get: -> parseInt @getAttribute('columns')
      set: (value)->
        @setAttribute('columns',value)
        update()

    update()

    for cell in @querySelectorAll('ui-cell')
      @insertBefore document.createTextNode('\u0020'), cell