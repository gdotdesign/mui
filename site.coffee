window.addEventListener 'load', ->
  pager = document.querySelector('body > ui-pager')
  window.componentPager =  document.querySelector('[name=components] > ui-pager')

  setHash = ->
    page = pager.selectedPage.getAttribute('name')
    if page is 'components' and componentPager.selectedPage
      page += "/"+componentPager.selectedPage.getAttribute('name')
    window.location.hash = page

  changePages = (str)->
    if str instanceof Event or str is undefined
      str = (window.location.hash[1..] or 'index')
    [page,component] = str.split('/')
    component ?= 'index'
    pager.select page
    componentPager.select component
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

