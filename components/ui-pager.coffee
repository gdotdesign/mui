#= require ../core/abstract

class UI.Page extends UI.Abstract
  @TAGNAME: 'page'

  initialize: ->
    Object.defineProperty @, 'active',
      get: -> !!@getAttribute 'active'
      set: (value) -> @toggleAttribute 'active', !!value

class UI.Pager extends UI.Abstract
  @TAGNAME: 'pager'

  select: (value)->
    return if @selectedPage is value

    @selectedPage?.active = false

    lastPage = @selectedPage
    if value instanceof HTMLElement
      if value.parentNode is @
        @selectedPage = value
    else
      @selectedPage = @querySelector(UI.Page.SELECTOR()+"[name='#{value}']")

    return unless @selectedPage

    @selectedPage.active = true

    @fireEvent 'change' if lastPage isnt @selectedPage
