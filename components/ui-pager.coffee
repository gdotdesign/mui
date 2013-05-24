#= require ../core/abstract

class UI.Page extends UI.Abstract
  @TAGNAME: 'page'
class UI.Pager extends UI.Abstract
  @TAGNAME: 'pager'
  select: (value)->
    UI.log 'PAGER: select', value
    lastPage = @selectedPage
    return if @selectedPage is value
    if value instanceof HTMLElement
      @selectedPage = value
    else
      @selectedPage = @querySelector(UI.Page.SELECTOR()+"[name='#{value}']")
    return unless @selectedPage
    @querySelector('[active]')?.removeAttribute('active')
    @selectedPage.setAttribute('active',true)
    if lastPage isnt @selectedPage
      @fireEvent('change')