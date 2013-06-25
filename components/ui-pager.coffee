#= require ../core/abstract
#= require ui-page

# Pager component
class UI.Pager extends UI.Abstract
  # The tagname of the component
  @TAGNAME: 'pager'

  # @property [UI.Page] The selected page component
  @set 'activePage', (value) -> @change value
  @get 'activePage', ->
    for child in @children
      if child.matchesSelector UI.Page.SELECTOR()+"[active]"
        return child

  # Selects next page
  next: -> @change @activePage.nextElementSibling

  # Selects previous page
  prev: -> @change @activePage.previousElementSibling

  # Selects a page
  #
  # Fires change event when active page changes
  # @param [UI.Page] The page to be selected
  change: (value)->
    if value instanceof HTMLElement
      if value.parentNode is @
        page = value
    else
      page = @querySelector(UI.Page.SELECTOR()+"[name='#{value}']")

    return unless page
    return if @activePage is page
    @activePage?.active = false
    page.active = true
    @fireEvent 'change'