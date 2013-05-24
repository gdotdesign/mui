#= require ../core/i-openable

class UI.Dropdown extends UI.iOpenable
  @TAGNAME: 'dropdown'

  onAdded: ->
    super
    @parentNode.addEventListener 'click', =>
      return if @disabled
      return if @parentNode.hasAttribute('disabled')
      @toggle()

  initialize: ->
    super ['top','bottom']

    document.addEventListener 'click', (e)=>
      @close() if e.target isnt @ and e.target isnt @parentNode
    , true