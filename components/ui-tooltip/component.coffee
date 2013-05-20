class UI.Tooltip extends UI.iOpenable
  @TAGNAME: 'tooltip'

  onAdded: ->
    super
    @parentNode.addEventListener 'mouseover', (e)=>
      return if @parentNode.hasAttribute('disabled') or @disabled
      unless getParent(e.target, 'ui-tooltip')
        @setAttribute('open',true)
    @parentNode.addEventListener 'mouseout', (e)=>
      @removeAttribute('open')

  initialize: ->
    super ['top','bottom','left','right']