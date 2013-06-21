window.addEventListener 'load', ->
  Array::.slice.call(document.querySelectorAll('ui-markup')).forEach (el)->
    el.textContent = html_beautify(el.innerHTML,{indent_size: 1, indent_char: '\t'})

  UI.initialize()
  UI.load()
  pager = document.querySelector('body > ui-pager')
  window.componentPager =  document.querySelector('[name=components] > ui-pager')
  dropdown = document.querySelector('header ui-dropdown')

  setHash = ->
    page = pager.activePage.getAttribute('name')
    if page is 'components' and componentPager.activePage
      page += "/"+componentPager.activePage.getAttribute('name')
    window.location.hash = page

  changePages = (str)->
    if str instanceof Event or str is undefined
      str = (window.location.hash[1..] or 'index')
    [page,component] = str.split('/')
    component ?= 'index'
    pager.change page
    componentPager.change component
    component = 'Components' if component is 'index'

  pager.addEventListener 'change', setHash
  componentPager.addEventListener 'change', setHash

  window.addEventListener 'hashchange', changePages
  changePages()
  document.addEventListener 'click', (e)->
    e.preventDefault()
    if (a = getParent(e.target,'a')) or (a = getParent(e.target,'ui-button'))
      if (name = a.getAttribute('target'))
        changePages(name)
        dropdown.close()
