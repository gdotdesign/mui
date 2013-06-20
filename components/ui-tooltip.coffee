#= require ../core/i-openable
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


class UI.Tooltip extends UI.iOpenable
  @TAGNAME: 'tooltip'

  _enter: (e)->
    return if @parentNode.hasAttribute('disabled') or @disabled
    return if getParent(e.target, UI.Tooltip.SELECTOR())
    @setAttribute('open',true)

  _leave: ->
    return if @parentNode.hasAttribute('disabled') or @disabled
    @removeAttribute('open')

  onAdded: ->
    super

    @parentNode.addEventListener UI.Events.enter, @_enter.bind(@)
    @parentNode.addEventListener UI.Events.leave, @_leave.bind(@)

  initialize: ->
    super ['top','bottom','left','right']