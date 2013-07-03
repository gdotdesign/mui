UI.initialize()

hljs.tabReplace = '    '
hljs.initHighlightingOnLoad()

window.addEventListener 'load', ->
	@pager = document.querySelector('ui-pager')
	document.addEventListener 'click', (e)->
		if e.target.matchesSelector('[target]')
			pager.activePage = e.target.getAttribute('target')