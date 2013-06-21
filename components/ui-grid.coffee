#= require ../core/abstract

# Cell component for Grid
class UI.Cell extends UI.Abstract
  @TAGNAME: 'cell'

# Placeholder component
class UI.Placeholder extends UI.Abstract
  @TAGNAME: 'placeholder'

# Grid component
class UI.Grid extends UI.Abstract
  @TAGNAME: 'grid'

  # @property [Number] Number of columns to map the cells.
  @get 'columns', -> parseInt @getAttribute('columns')
  @set 'columns', (value)->
    @setAttribute 'columns', parseInt(value)
    @_update()

  # Updates placeholders
  # @private
  _update: ->
    for el in Array::slice.call @querySelectorAll(UI.Placeholder.SELECTOR())
      el.parentNode.removeChild el
    @normalize()
    cells = @querySelectorAll(UI.Cell.SELECTOR()).length
    diff = @columns-cells%@columns
    unless diff is @columns
      for i in [1..diff]
        @appendChild document.createTextNode '\u0020'
        @appendChild document.createElement UI.Placeholder.SELECTOR()
      @normalize()
    @_updating = false

  # Initalizes the components
  # @private
  initialize: ->
    @_update()

    @addEventListener 'DOMNodeRemoved', =>
      return if @_updating
      @_updating = true
      setTimeout @_update.bind(@)
    @addEventListener 'DOMNodeInserted', =>
      return if @_updating
      @_updating = true
      @_update()

    for cell in @querySelectorAll('ui-cell')
      @insertBefore document.createTextNode('\u0020'), cell