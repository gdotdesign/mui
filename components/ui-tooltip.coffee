#= require ../core/i-openable

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

    @parentNode.addEventListener UI.Events.enter, @_enter
    @parentNode.addEventListener UI.Events.leave, @_leave

  initialize: ->
    super ['top','bottom','left','right']