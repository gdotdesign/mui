# HighlightJS
hljs.tabReplace = '    '
hljs.initHighlightingOnLoad()

window.addEventListener 'load', ->
  @pager = document.querySelector('ui-pager')
  @addEventListener 'hashchange', ->
    @pager.activePage = @location.hash[1..]
  document.addEventListener 'click', (e)=>
    if e.target.matchesSelector('[target]')
      @location.hash = e.target.getAttribute('target')
  @pager.activePage = @location.hash[1..]