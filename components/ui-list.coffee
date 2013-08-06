#= require ../core/abstract
class UI.List extends UI.Abstract
  @TAGNAME: 'list'

  remove: (el)->
    el.setAttribute 'removed', true
    remove = (=>
      return unless el.parentNode
      @removeChild el
    ).once()
    if window.animationSupport
      for type in ['animationend','webkitAnimationEnd','oanimationend','MSAnimationEnd']
        el.addEventListener type, remove
    else
      @removeChild el
