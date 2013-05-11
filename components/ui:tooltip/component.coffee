class UI.Tooltip extends UI.Abstract
  @TAGNAME: 'tooltip'

  onAdded: ->
    @parentNode.addEventListener 'mouseover', (e)=>
      unless getParent(e.target, 'ui:tooltip')
        @setAttribute('open',true)
    @parentNode.addEventListener 'mouseout', (e)=>
      @removeAttribute('open')

  initialize: ->
    @onAdded() if @parentNode