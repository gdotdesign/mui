Test.add 'Pager', ->
  component = document.querySelector(UI.Pager.SELECTOR())

  @case 'ActivePage should return active page', ->
    @assert component.activePage is document.querySelector(UI.Page.SELECTOR()+"[active]")

  @case 'ActivePage should set the active page', ->
    page = document.querySelector(UI.Page.SELECTOR()+":not([active])")
    component.activePage = page
    @assert page.active

  @case 'Change should fire change event', ->
    page = document.querySelector(UI.Page.SELECTOR()+":not([active])")
    x = false
    fn = -> x = true
    component.addEventListener 'change', fn
    component.change page
    @assert x

  @case 'Change select by name', ->
    page = document.querySelector(UI.Page.SELECTOR()+"[name]")
    name = page.getAttribute('name')
    component.change name
    @assert page.active

  @case 'Next should select next page', ->
    page = document.querySelector(UI.Page.SELECTOR()+":not([active])")
    component.next()
    @assert page.active

  @case 'Prev should select previous page', ->
    page = document.querySelector(UI.Page.SELECTOR()+":not([active])")
    component.prev()
    @assert page.active